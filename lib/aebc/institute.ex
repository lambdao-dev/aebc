defmodule Aebc.Institute do
  @moduledoc """
  The Institute context.
  """

  use Tesla

  # Plug in middleware for JSON and setting the base URL
  plug Tesla.Middleware.BaseUrl, "http://localhost:1337/api"
  plug Tesla.Middleware.JSON

  # defp base_url do
  #   Application.fetch_env!(:institute, :strapi)[:base_url]
  # end

  # Helper to parse the common Strapi response structure
  defp parse_response({:ok, %Tesla.Env{status: 200, body: %{"data" => data}}}) do
    {:ok, data}
  end

  defp parse_response({:ok, %Tesla.Env{status: 404, body: %{"error" => data}}}) do
    {:error, data}
  end

  defp parse_response(response) do
    response
  end

  # Optional: For authenticated requests later, you can add a header
  # plug Tesla.Middleware.Headers, [{"Authorization", "Bearer #{System.get_env("STRAPI_API_TOKEN")}"}]

  def fetch_single_page(slug, locale \\ "fr") do
    get("/#{slug}?locale=#{locale}") |> parse_response()
  end

  def get(model, id, locale \\ "fr", populate \\ nil, opts \\ %{}) do
    url = "/#{model}/#{id}?locale=#{locale}"
    url = if populate, do: "#{url}&#{build_populate_query(populate)}", else: url
    params = Enum.map(opts, fn {key, value} -> "#{key}=#{value}" end)
    url = case params do
      [] -> url
      _ -> url <> "&" <> Enum.join(params, "&")
    end
    url |> get |> parse_response()
  end

  def get_all(model, locale \\ "fr", populate \\ nil, opts \\ %{}) do
    url = "/#{model}?locale=#{locale}"
    url = if populate, do: "#{url}&#{build_populate_query(populate)}", else: url
    params = Enum.map(opts, fn {key, value} -> "#{key}=#{value}" end)
    url = case params do
      [] -> url
      _ -> url <> "&" <> Enum.join(params, "&")
    end
    url |> get |> parse_response()
  end

  defp build_populate_query(populate) when is_list(populate) do
    populate
    |> Enum.map(&"populate=#{&1}")
    |> Enum.join("&")
  end
  defp build_populate_query(populate), do: "populate=#{populate}"

  def add_photo_url(dic, placeholder \\ "/uploads/avatar_67198181e0.png") do
    url = get_in(dic, ["photo", "url"]) || get_in(dic, ["photo", "formats", "small", "url"]) || get_in(dic, ["photo", "formats", "thumbnail", "url"]) || placeholder
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
    resp = post(url, params)
    parse_response(resp)
  end
end
