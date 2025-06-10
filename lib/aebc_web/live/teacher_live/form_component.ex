defmodule AebcWeb.TeacherLive.FormComponent do
  use AebcWeb, :live_component

  alias Aebc.Institute

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage teacher records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="teacher-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Teacher</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{teacher: teacher} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Institute.change_teacher(teacher))
     end)}
  end

  @impl true
  def handle_event("validate", %{"teacher" => teacher_params}, socket) do
    changeset = Institute.change_teacher(socket.assigns.teacher, teacher_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"teacher" => teacher_params}, socket) do
    save_teacher(socket, socket.assigns.action, teacher_params)
  end

  defp save_teacher(socket, :edit, teacher_params) do
    case Institute.update_teacher(socket.assigns.teacher, teacher_params) do
      {:ok, teacher} ->
        notify_parent({:saved, teacher})

        {:noreply,
         socket
         |> put_flash(:info, "Teacher updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_teacher(socket, :new, teacher_params) do
    case Institute.create_teacher(teacher_params) do
      {:ok, teacher} ->
        notify_parent({:saved, teacher})

        {:noreply,
         socket
         |> put_flash(:info, "Teacher created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
