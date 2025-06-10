defmodule AebcWeb.TeacherLive.Show do
  use AebcWeb, :live_view

  alias Aebc.Institute

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:teacher, Institute.get_teacher!(id))}
  end

  defp page_title(:show), do: "Show Teacher"
  defp page_title(:edit), do: "Edit Teacher"
end
