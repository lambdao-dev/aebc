defmodule AebcWeb.AdministratorLive.Show do
  use AebcWeb, :live_view
  use Phoenix.LiveView,
    layout: {AebcWeb.Layouts, :app_simple}

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(%{"id" => cid} = params, _session, socket) do
    locale = Map.get(params, "locale", Gettext.get_locale(AebcWeb.Gettext))
    Gettext.put_locale(AebcWeb.Gettext, locale)

    {status, resp} = Institute.get("administrators", cid, locale, ["photo"])
    administrator = case status do
      :ok -> Institute.add_photo_url(resp)
      _error -> nil
    end

    if administrator do
    socket =
      assign(socket,
        page_title: "Administrators",
        locale: locale,
        administrator: administrator
      )

      {:ok, socket}
    else
      {:ok,
       socket
       |> Phoenix.LiveView.put_flash(:error, "Administrator not found")
       |> Phoenix.LiveView.redirect(to: "/404")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Administrator") %> {@administrator["name"]}
    </.header>

    <img
      class="w-full h-48 object-cover mt-8 mb-8"
      src={@administrator["photo_url"]}
      alt={@administrator["name"]}
    />

    <%= raw(@administrator["description"]) %>

    <.back navigate={~p"/administrators"}>
      <%= gettext("Back to administrators") %>
    </.back>
    """
  end
end
