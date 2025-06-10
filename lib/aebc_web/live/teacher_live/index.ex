defmodule AebcWeb.TeacherLive.Index do
  use AebcWeb, :live_view

  alias Aebc.Institute
  alias Aebc.Institute.Teacher

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :teachers, Institute.list_teachers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Teacher")
    |> assign(:teacher, Institute.get_teacher!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Teacher")
    |> assign(:teacher, %Teacher{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Teachers")
    |> assign(:teacher, nil)
  end

  @impl true
  def handle_info({AebcWeb.TeacherLive.FormComponent, {:saved, teacher}}, socket) do
    {:noreply, stream_insert(socket, :teachers, teacher)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    teacher = Institute.get_teacher!(id)
    {:ok, _} = Institute.delete_teacher(teacher)

    {:noreply, stream_delete(socket, :teachers, teacher)}
  end
end
