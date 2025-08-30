defmodule AebcWeb.CourseLive.Index do
  use AebcWeb, :live_view

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", Gettext.get_locale(AebcWeb.Gettext))
    Gettext.put_locale(AebcWeb.Gettext, locale)
    {status, resp} = Institute.get_all("Courses", locale, "photo")
    courses = case status do
      :ok -> resp
      _error -> []
    end
    courses = Enum.map(courses, &Institute.add_photo_url/1)
    socket =
      assign(socket,
        page_title: "courses",
        locale: locale,
        courses: courses
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Courses") %>
    </.header>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div :for={course <- @courses} class="border p-4 rounded-lg shadow">
        <.link navigate={~p"/courses/#{course["id"]}"} class="text-xl font-bold">
          <h2><%= course["name"] %></h2>
          <img class="w-full h-48 object-cover" src={course["photo_url"]} alt={course["name"]} />
        </.link>
      </div>
    </div>
    """
  end
end
