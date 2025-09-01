defmodule AebcWeb.CourseLive.Show do
  use AebcWeb, :live_view
  use Phoenix.LiveView,
    layout: {AebcWeb.Layouts, :app_wide}

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(%{"id" => cid}, session, socket) do
    locale = Gettext.get_locale(AebcWeb.Gettext)
    {status, resp} = Institute.get("courses", cid, locale, ["photo", "teacher"])
    course = case status do
      :ok -> Institute.add_photo_url(resp)
      _error -> nil
    end

    if course do
    socket =
      assign(socket,
        page_title: course["name"],
        locale: locale,
        course: course
      )

    {:ok, socket}
    else
      {:ok,
       socket
       |> Phoenix.LiveView.put_flash(:error, "Course not found")
       |> Phoenix.LiveView.redirect(to: "/404")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Course") %> {@course["name"]}
      <:subtitle>{@course["short"]}</:subtitle>
    </.header>

    <img class="w-full h-48 object-cover" src={@course["photo_url"]} alt={@course["name"]} />

    <%= raw(@course["description"]) %>

    <%= if @course["teacher"] do %>
      <h2><%= gettext("Teacher") %></h2>
      <.link navigate={~p"/teachers/#{@course["teacher"]["id"]}"}>
        <%= @course["teacher"]["name"] %>
      </.link>
    <% end %>

    <.back navigate={~p"/courses"}>
      <%= gettext("Back to courses") %>
    </.back>
    """
  end
end
