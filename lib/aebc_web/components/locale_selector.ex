defmodule AebcWeb.LocaleSelector do
  use Phoenix.Component
  use Gettext, backend: AebcWeb.Gettext

  def locale_selector(assigns) do
    ~H"""
    <div class="flex items-center gap-2">
      <%= for locale <- Gettext.known_locales(AebcWeb.Gettext) do %>
      <button
          id={"locale-selector-#{locale}"}
          phx-hook="LocaleSelector"
          data-locale={locale}
          class={[
            "px-2 py-1 rounded text-sm",
            Gettext.get_locale(AebcWeb.Gettext) == locale && "bg-zinc-300 text-white",
            Gettext.get_locale(AebcWeb.Gettext) != locale && "text-black hover:text-zinc-900"
          ]}
        >
          <%= String.upcase(locale) %>
        </button>
      <% end %>
    </div>
    """
  end
end
