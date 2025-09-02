defmodule AebcWeb.EventLive.Index do
  use AebcWeb, :live_view

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  import AebcWeb.DateHelper

  @impl true
  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", Gettext.get_locale(AebcWeb.Gettext))
    Gettext.put_locale(AebcWeb.Gettext, locale)
    {status, resp} = Institute.get_all("events", locale, "photo")
    events = case status do
      :ok -> resp
      _error -> []
    end
    events = Enum.map(events, &Institute.add_photo_url/1)
    socket =
      assign(socket,
        page_title: "Events",
        locale: locale,
        events: events
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Events") %>
    </.header>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div :for={event <- @events} class="border p-4 rounded-lg shadow">
        <.link navigate={~p"/events/#{event["id"]}"} class="text-xl font-bold">
          <h2><%= event["name"] %> <%= format_date(event["date_start"]) %></h2>
          <img class="w-full h-48 object-cover" src={event["photo_url"]} alt={event["name"]} />
        </.link>
      </div>
    </div>
    """
  end
end
