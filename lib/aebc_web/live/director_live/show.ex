defmodule AebcWeb.DirectorLive.Show do
  use AebcWeb, :live_view
  use Phoenix.LiveView,
    layout: {AebcWeb.Layouts, :app_wide}

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(%{"id" => cid}, session, socket) do
    locale = Gettext.get_locale(AebcWeb.Gettext)
    {status, resp} = Institute.get("directors", cid, locale, ["photo"])
    director = case status do
      :ok -> Institute.add_photo_url(resp)
      _error -> nil
    end

    if director do
    socket =
      assign(socket,
        page_title: "Directors",
        locale: locale,
        director: director
      )

      {:ok, socket}
    else
      {:ok,
       socket
       |> Phoenix.LiveView.put_flash(:error, "Director not found")
       |> Phoenix.LiveView.redirect(to: "/404")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Director") %> {@director["name"]}
    </.header>

    <img class="w-full h-48 object-cover" src={@director["photo_url"]} alt={@director["name"]} />

    <%= raw(@director["description"]) %>

    <.back navigate={~p"/directors"}>
      <%= gettext("Back to directors") %>
    </.back>
    """
  end
end
