include_strapi? =
  System.get_env("STRAPI_INTEGRATION", "")
  |> String.downcase()
  |> then(&(&1 in ["1", "true", "yes"]))

ExUnit.start(exclude: [strapi_integration: !include_strapi?])
