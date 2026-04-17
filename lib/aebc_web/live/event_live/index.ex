defmodule AebcWeb.EventLive.Index do
  use AebcWeb, :live_view

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  import AebcWeb.DateHelper

  @impl true
  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", Gettext.get_locale(AebcWeb.Gettext))
    Gettext.put_locale(AebcWeb.Gettext, locale)
    today = Date.utc_today() |> Date.to_iso8601()

    {status, resp} = Institute.get_all("events", locale, "photo", %{
      "filters[date_start][$gte]" => today,
      "sort[0]" => "date_start:asc"
    })
    future_events = case status do
      :ok -> Enum.map(resp, &Institute.add_photo_url/1)
      _error -> []
    end

    {status, resp} = Institute.get_all("events", locale, "photo", %{
      "filters[date_start][$lt]" => today,
      "sort[0]" => "date_start:desc"
    })
    past_events = case status do
      :ok -> Enum.map(resp, &Institute.add_photo_url/1)
      _error -> []
    end

    socket =
      assign(socket,
        page_title: "Events",
        locale: locale,
        future_events: future_events,
        past_events: past_events
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
      <div :for={event <- @future_events} class="border p-4 rounded-lg shadow">
        <.link navigate={~p"/events/#{event["id"]}"} class="text-xl font-bold">
          <h2><%= event["name"] %> <%= format_date(event["date_start"]) %></h2>
          <img class="w-full h-48 object-cover" src={event["photo_url"]} alt={event["name"]} />
        </.link>
      </div>
    </div>

    <div :if={@past_events != []}>
      <h2 class="text-2xl font-bold mt-10 mb-4"><%= gettext("Archived Events") %></h2>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div :for={event <- @past_events} class="border p-4 rounded-lg shadow opacity-75">
          <.link navigate={~p"/events/#{event["id"]}"} class="text-xl font-bold">
            <h2><%= event["name"] %> <%= format_date(event["date_start"]) %></h2>
            <img class="w-full h-48 object-cover" src={event["photo_url"]} alt={event["name"]} />
          </.link>
        </div>
      </div>
    </div>
    """
  end
end
