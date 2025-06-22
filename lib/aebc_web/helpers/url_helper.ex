defmodule AebcWeb.UrlHelper do
  @moduledoc """
  Helper functions for URL generation and manipulation.
  """

  @doc """
  Returns the configured Strapi URL prefix.
  """
  def strapi_url_prefix do
    Application.get_env(:aebc, :strapi)[:url_prefix] || "http://localhost:1337"
  end

  @doc """
  Builds a full URL by prepending the Strapi URL prefix to the given path.
  """
  def strapi_url(path) when is_binary(path) do
    strapi_url_prefix() <> path
  end
end
