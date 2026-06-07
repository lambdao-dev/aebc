defmodule AebcWeb.Router do
  use AebcWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AebcWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AebcWeb.Plugs.Locale, "fr"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AebcWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/about", PageController, :about
    get "/institute", PageController, :institute
    get "/download", PageController, :download
    get "/hsk", PageController, :hsk
    get "/contact", PageController, :contact_page
    live "/courses", CourseLive.Index, :index
    live "/courses/:id", CourseLive.Show, :show
    live "/teachers", TeacherLive.Index, :index
    live "/teachers/:id", TeacherLive.Show, :show
    live "/posts", PostLive.Index, :index
    live "/posts/:id", PostLive.Show, :show
    live "/events", EventLive.Index, :index
    live "/events/:id", EventLive.Show, :show
    live "/administrators", AdministratorLive.Index, :index
    live "/administrators/:id", AdministratorLive.Show, :show
    match :*, "/*path", PageController, :not_found
  end

  # Other scopes may use custom stacks.
  # scope "/api", AebcWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:aebc, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AebcWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
