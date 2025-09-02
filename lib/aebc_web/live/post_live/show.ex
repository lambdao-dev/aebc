defmodule AebcWeb.PostLive.Show do
  use AebcWeb, :live_view
  use Phoenix.LiveView,
    layout: {AebcWeb.Layouts, :app_simple}

  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  @impl true
  def mount(%{"id" => cid} = params, _session, socket) do
    locale = Map.get(params, "locale", Gettext.get_locale(AebcWeb.Gettext))
    Gettext.put_locale(AebcWeb.Gettext, locale)

    {status, resp} = Institute.get("posts", cid, locale, ["photo"])
    post = case status do
      :ok -> Institute.add_photo_url(resp)
      _error -> nil
    end

    if post do
    socket =
      assign(socket,
        page_title: "Posts",
        locale: locale,
        post: post
      )

      {:ok, socket}
    else
      {:ok,
       socket
       |> Phoenix.LiveView.put_flash(:error, "Post not found")
       |> Phoenix.LiveView.redirect(to: "/404")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Post") %> {@post["name"]}
    </.header>

    <img class="w-full h-48 object-cover" src={@post["photo_url"]} alt={@post["name"]} />

    <%= raw(@post["description"]) %>

    <.back navigate={~p"/posts"}>
      <%= gettext("Back to posts") %>
    </.back>
    """
  end
end
