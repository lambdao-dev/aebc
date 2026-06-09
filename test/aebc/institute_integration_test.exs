defmodule Aebc.InstituteIntegrationTest do
  use ExUnit.Case, async: false

  alias Aebc.Institute

  @moduletag :strapi_integration

  test "configured Strapi instance exposes the required single types" do
    for slug <- ~w(home about institute hsk download contact-page),
        locale <- ~w(fr en) do
      assert {:ok, %{"main" => main}} = Institute.fetch_single_page(slug, locale)
      assert is_binary(main)
    end
  end

  test "configured Strapi instance exposes the required collections" do
    for model <- ~w(courses teachers administrators events posts),
        locale <- ~w(fr en) do
      assert {:ok, entries} = Institute.get_all(model, locale)
      assert is_list(entries)
    end
  end
end
