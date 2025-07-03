defmodule AebcWeb.ContactLive do
  use Phoenix.LiveView
  use Gettext, backend: AebcWeb.Gettext
  import AebcWeb.ContactForm
  import AebcWeb.TurnstileHelper
  alias Aebc.Institute

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, form_submitted: false, page_title: gettext("Contact Us"), layout: {AebcWeb.Layouts, "app_simple"})}
  end

  @impl true
  def handle_event("submit_contact", params, socket) do
    case Turnstile.verify(params) do
      {:ok, _} ->
        contact = params["contact"]
        contact = Map.put(contact, "done", false)
        payload = %{"data" => contact}
        Institute.create_contact(payload)
        {:noreply, assign(socket, form_submitted: true)}

      {:error, error_message} ->
        socket =
          socket
          |> put_flash(:error, gettext("Verification failed. Please try again."))
          |> Turnstile.refresh()

        {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
      <.contact_form current_path={@page_title} form_submitted={@form_submitted} />
    """
  end

  defp verify_turnstile_token(token, socket) do
    # Get client IP if available
    remote_ip = get_remote_ip(socket)

    if remote_ip do
      verify_token(token, remote_ip)
    else
      verify_token(token)
    end
  end

  defp get_remote_ip(socket) do
    # Try to get IP from various sources
    socket.assigns[:remote_ip] ||
    socket.private[:connect_info][:peer_data][:address] ||
    nil
  end
end
