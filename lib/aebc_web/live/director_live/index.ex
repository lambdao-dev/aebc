defmodule AebcWeb.DirectorLive.Index do
  use AebcWeb, :live_view

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", Gettext.get_locale(AebcWeb.Gettext))
    Gettext.put_locale(AebcWeb.Gettext, locale)
    {status, resp} = Institute.get_all("directors", locale, "photo")
    directors = case status do
      :ok -> resp
      _error -> []
    end
    directors = Enum.map(directors, &Institute.add_photo_url/1)
    socket =
      assign(socket,
        page_title: "Directors",
        locale: locale,
        directors: directors
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Directors
    </.header>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div :for={director <- @directors} class="border p-4 rounded-lg shadow">
        <.link navigate={~p"/directors/#{director["id"]}"} class="text-xl font-bold">
          <h2><%= director["name"] %></h2>
          <img class="w-full h-48 object-cover" src={director["photo_url"]} alt={director["name"]} />
        </.link>
      </div>
    </div>
    """
  end
end
