defmodule AebcWeb.ContactLive do
  use Phoenix.LiveView
  use Gettext, backend: AebcWeb.Gettext
  import AebcWeb.ContactForm
  alias Aebc.Institute

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: gettext("Contact Us"), layout: {AebcWeb.Layouts, "app_simple"})}
  end

  @impl true
  def handle_event("submit_contact", params, socket) do
    contact = params["contact"]
    contact = Map.put(contact, "done", false)
    payload = %{"data" => contact}
    Institute.create_contact(payload)
    {:noreply,
     socket
     |> put_flash(:info, gettext("Thank you for your question. We'll get back to you soon!"))
     |> assign(:form_submitted, true)}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <.contact_form current_path={@page_title} />
    """
  end
end
