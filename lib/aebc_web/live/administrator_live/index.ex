defmodule AebcWeb.AdministratorLive.Index do
  use AebcWeb, :live_view

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", Gettext.get_locale(AebcWeb.Gettext))
    Gettext.put_locale(AebcWeb.Gettext, locale)
    {status, resp} = Institute.get_all("administrators", locale, "photo")
    administrators = case status do
      :ok -> resp
      _error -> []
    end
    administrators = Enum.map(administrators, &Institute.add_photo_url/1)
    socket =
      assign(socket,
        page_title: "Administrators",
        locale: locale,
        administrators: administrators
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Administrators") %>
    </.header>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div :for={administrator <- @administrators} class="border p-4 rounded-lg shadow">
        <.link navigate={~p"/administrators/#{administrator["id"]}"} class="text-xl font-bold">
          <h2><%= administrator["name"] %></h2>
          <img class="w-full h-48 object-cover" src={administrator["photo_url"]} alt={administrator["name"]} />
        </.link>
      </div>
    </div>
    """
  end
end
