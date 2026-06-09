defmodule AebcWeb.CourseLive.Show do
  use AebcWeb, :simple_live_view

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(%{"id" => cid} = params, _session, socket) do
    locale = Map.get(params, "locale", Gettext.get_locale(AebcWeb.Gettext))
    Gettext.put_locale(AebcWeb.Gettext, locale)

    {status, resp} = Institute.get("courses", cid, locale, ["photo", "teacher"])

    course =
      case status do
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
      {gettext("Course")} {@course["name"]}
      <:subtitle>{@course["short"]}</:subtitle>
    </.header>

    <img class="w-full h-48 object-cover mt-8 mb-8" src={@course["photo_url"]} alt={@course["name"]} />

    {raw(@course["description"])}

    <%= if @course["teacher"] do %>
      <div class="border border-gray-300 rounded-lg p-6 bg-gray-50 mt-10 max-w-[50%]">
        <h2 class="text-2xl font-semibold mb-4 px-4 py-2 bg-blue-100 rounded text-blue-900">
          {gettext("Teacher")}
        </h2>

        <.link
          navigate={~p"/teachers/#{@course["teacher"]["id"]}"}
          class="text-blue-600 hover:underline px-2"
        >
          {@course["teacher"]["name"]}
        </.link>
      </div>
    <% end %>

    <.back navigate={~p"/courses"}>
      {gettext("Back to courses")}
    </.back>
    """
  end
end
