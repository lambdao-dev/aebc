defmodule AebcWeb.EventLive.Show do
  use AebcWeb, :live_view
  use Phoenix.LiveView,
    layout: {AebcWeb.Layouts, :app_simple}

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(%{"id" => cid}, session, socket) do
    locale = Gettext.get_locale(AebcWeb.Gettext)
    {status, resp} = Institute.get("events", cid, locale, ["photo"])
    event = case status do
      :ok -> Institute.add_photo_url(resp)
      _error -> nil
    end

    if event do
    socket =
      assign(socket,
        page_title: "Events",
        locale: locale,
        event: event
      )

      {:ok, socket}
    else
      {:ok,
       socket
       |> Phoenix.LiveView.put_flash(:error, "Event not found")
       |> Phoenix.LiveView.redirect(to: "/404")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Event") %> {@event["name"]}
    </.header>

    <img class="w-full h-48 object-cover" src={@event["photo_url"]} alt={@event["name"]} />

    <%= raw(@event["description"]) %>

    <.back navigate={~p"/events"}>
      <%= gettext("Back to events") %>
    </.back>
    """
  end
end
