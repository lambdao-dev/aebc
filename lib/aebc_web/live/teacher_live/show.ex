defmodule AebcWeb.TeacherLive.Show do
  use AebcWeb, :live_view
  use Phoenix.LiveView,
    layout: {AebcWeb.Layouts, :app_simple}

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(%{"id" => cid} = params, _session, socket) do
    locale = Map.get(params, "locale", Gettext.get_locale(AebcWeb.Gettext))
    Gettext.put_locale(AebcWeb.Gettext, locale)

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

    <img
      class="w-full h-48 object-cover mt-8 mb-8"
      src={@teacher["photo_url"]}
      alt={@teacher["name"]}
    />

    <%= raw(@teacher["description"]) %>

    <%= if !Enum.empty?(@teacher["courses"]) do %>
      <div class="border border-gray-300 rounded-lg p-6 bg-gray-50 mt-10">
        <h2 class="text-2xl font-semibold mb-4 px-4 py-2 bg-blue-100 rounded text-blue-900">
          <%= gettext("Courses") %>
        </h2>

        <ul class="space-y-2 px-2">
          <%= for course <- @teacher["courses"] do %>
            <li>
              <.link navigate={~p"/courses/#{course["id"]}"} class="text-blue-600 hover:underline">
                <%= course["name"] %>
              </.link>
            </li>
          <% end %>
        </ul>
      </div>
    <% end %>

    <.back navigate={~p"/teachers"}>
      <%= gettext("Back to teachers") %>
    </.back>
    """
  end
end
