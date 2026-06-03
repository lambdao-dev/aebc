defmodule AebcWeb.ContactLive do
  use AebcWeb, :live_view
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", Gettext.get_locale(AebcWeb.Gettext))
    Gettext.put_locale(AebcWeb.Gettext, locale)
    {:ok, assign(socket, page_title: gettext("Contact"), locale: locale)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Contact") %>
    </.header>

    <div class="mt-8 space-y-6 text-sm text-zinc-700">
      <div>
        <p class="font-semibold"><%= gettext("Address") %></p>
        <p>Quai Mativa 37, 4020 Liège, Belgique</p>
      </div>

      <div>
        <p class="font-semibold"><%= gettext("Phone") %></p>
        <p>0032 468 36 65 36</p>
        <p>0032 475 68 88 18</p>
      </div>

      <div>
        <p class="font-semibold"><%= gettext("Email") %></p>
        <p><a href="mailto:aebcasbl@hotmail.com" class="text-blue-600 hover:underline">aebcasbl@hotmail.com</a></p>
      </div>
    </div>
    """
  end
end
