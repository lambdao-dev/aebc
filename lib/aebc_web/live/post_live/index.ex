defmodule AebcWeb.PostLive.Index do
  use AebcWeb, :live_view

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(_params, session, socket) do
    locale = Gettext.get_locale(AebcWeb.Gettext)
    {status, resp} = Institute.get_all("posts", locale)
    posts = case status do
      :ok -> resp
      _error -> []
    end
    #posts = Enum.map(posts, &Institute.add_photo_url/1)
    socket =
      assign(socket,
        page_title: "Posts",
        locale: locale,
        posts: posts
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Posts") %>
    </.header>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div :for={post <- @posts} class="border p-4 rounded-lg shadow">
        <.link navigate={~p"/posts/#{post["id"]}"} class="text-xl font-bold">
          <h2><%= post["name"] %></h2>

        </.link>
      </div>
    </div>
    """
  end
end
