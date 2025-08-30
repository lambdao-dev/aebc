defmodule AebcWeb.TeacherLive.Index do
  use AebcWeb, :live_view

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(params, _session, socket) do
    locale = Map.get(params, "locale", Gettext.get_locale(AebcWeb.Gettext))
    Gettext.put_locale(AebcWeb.Gettext, locale)
    {status, resp} = Institute.get_all("teachers", locale, "photo")
    teachers = case status do
      :ok -> resp
      _error -> []
    end
    teachers = Enum.map(teachers, &Institute.add_photo_url/1)
    socket =
      assign(socket,
        page_title: "Teachers",
        locale: locale,
        teachers: teachers
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Teachers") %>
    </.header>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div :for={teacher <- @teachers} class="border p-4 rounded-lg shadow">
        <.link navigate={~p"/teachers/#{teacher["id"]}"} class="text-xl font-bold">
          <h2><%= teacher["name"] %></h2>
          <img class="w-full h-48 object-cover" src={teacher["photo_url"]} alt={teacher["name"]} />
        </.link>
      </div>
    </div>
    """
  end
end
