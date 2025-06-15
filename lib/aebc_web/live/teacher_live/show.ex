defmodule AebcWeb.TeacherLive.Show do
  use AebcWeb, :live_view

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(%{"id" => cid}, session, socket) do
    locale = Gettext.get_locale(AebcWeb.Gettext)
    {status, resp} = Institute.get("teachers", cid, locale, ["photo", "courses"])
    teacher = case status do
      :ok -> Institute.add_photo_url(resp)
      _error -> nil
    end

    if teacher do
    socket =
      assign(socket,
        page_title: "Teachers",
        locale: locale,
        teacher: teacher
      )

      {:ok, socket}
    else
      {:ok,
       socket
       |> Phoenix.LiveView.put_flash(:error, "Teacher not found")
       |> Phoenix.LiveView.redirect(to: "/404")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Teacher") %> {@teacher["name"]}
    </.header>

    <img class="w-full h-48 object-cover" src={@teacher["photo_url"]} alt={@teacher["name"]} />

    <%= raw(@teacher["description"]) %>

    <%= if !Enum.empty?(@teacher["courses"]) do %>
    <h2><%= gettext("Courses") %></h2>
    <ul>
      <%= for course <- @teacher["courses"] do %>
        <li><.link navigate={~p"/courses/#{course["id"]}"}>
            <%= course["name"] %>
          </.link>
        </li>
        <% end %>
      </ul>
    <% end %>

    <.back navigate={~p"/teachers"}>
      <%= gettext("Back to teachers") %>
    </.back>
    """
  end
end
