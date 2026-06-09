defmodule Aebc.Institute do
  @moduledoc """
  The Institute context.
  """

  defp client do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, api_url()},
      Tesla.Middleware.JSON
    ])
  end

  def api_url do
    Application.fetch_env!(:aebc, :strapi)
    |> Keyword.fetch!(:api_url)
  end

  # Helper to parse the common Strapi response structure
  defp parse_response({:ok, %Tesla.Env{status: 200, body: %{"data" => data}}}) do
    {:ok, data}
  end

  defp parse_response({:ok, %Tesla.Env{status: _status, body: %{"error" => data}}}) do
    {:error, data}
  end

  defp parse_response({:ok, %Tesla.Env{status: status}}) do
    {:error, "HTTP #{status}"}
  end

  defp parse_response({:error, reason}) do
    {:error, reason}
  end

  # Optional: For authenticated requests later, you can add a header
  # plug Tesla.Middleware.Headers, [{"Authorization", "Bearer #{System.get_env("STRAPI_API_TOKEN")}"}]

  def fetch_single_page(slug, locale \\ "fr") do
    Tesla.get(client(), "/#{slug}?locale=#{locale}") |> parse_response()
  end

  def get(model, id, locale \\ "fr", populate \\ nil, opts \\ %{}) do
    url = "/#{model}/#{id}?locale=#{locale}"
    url = if populate, do: "#{url}&#{build_populate_query(populate)}", else: url
    url = if opts != %{}, do: url <> "&" <> URI.encode_query(opts), else: url
    Tesla.get(client(), url) |> parse_response()
  end

  def get_all(model, locale \\ "fr", populate \\ nil, opts \\ %{}) do
    url = "/#{model}?locale=#{locale}"
    url = if populate, do: "#{url}&#{build_populate_query(populate)}", else: url
    url = if opts != %{}, do: url <> "&" <> URI.encode_query(opts), else: url
    Tesla.get(client(), url) |> parse_response()
  end

  defp build_populate_query(populate) when is_list(populate) do
    populate
    |> Enum.map(&"populate=#{&1}")
    |> Enum.join("&")
  end

  defp build_populate_query(populate), do: "populate=#{populate}"

  def add_photo_url(dic, placeholder \\ "/uploads/avatar_67198181e0.png") do
    url =
      get_in(dic, ["photo", "url"]) || get_in(dic, ["photo", "formats", "small", "url"]) ||
        get_in(dic, ["photo", "formats", "thumbnail", "url"]) || placeholder

    prefix = AebcWeb.UrlHelper.strapi_url_prefix()
    Map.put(dic, "photo_url", prefix <> url)
  end

  def create_contact(params) do
    # Data shape:
    # {
    #   "data": {
    #     "email": "user@example.com",
    #     "page": "string",
    #     "question": "string",
    #     "done": true,
    #     "comment": "string"
    #   }
    # }
    url = "/contacts"
    resp = Tesla.post(client(), url, params)
    parse_response(resp)
  end
end
