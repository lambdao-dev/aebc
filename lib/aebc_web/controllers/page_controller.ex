defmodule AebcWeb.PageController do
  use AebcWeb, :controller
  alias Aebc.Institute
  use Gettext, backend: AebcWeb.Gettext

  def not_found(conn, _params) do
    conn
    |> put_status(:not_found)
    |> put_view(AebcWeb.ErrorHTML)
    |> render("404.html")
  end

  def single_page(name, template, conn) do
    locale = Gettext.get_locale(AebcWeb.Gettext)
    {status, resp} = Institute.fetch_single_page(name, locale)

    content =
      case status do
        :ok -> resp
        _error -> nil
      end

    conn
    |> assign(:content, content)
    |> assign(:page_title, name)
    |> render(template)
  end

  def home(conn, _params) do
    locale = Gettext.get_locale(AebcWeb.Gettext)
    {status, resp} = Institute.fetch_single_page("home", locale)

    content =
      case status do
        :ok -> resp
        _error -> %{"main" => ""}
      end

    {status, events} = Institute.get_all("events", locale, nil, %{"pagination.pageSize": 5})

    events =
      case status do
        :ok -> events
        _error -> []
      end

    {status, latest_news} = Institute.get_all("posts", locale, nil, %{"pagination.pageSize": 5})

    latest_news =
      case status do
        :ok -> latest_news
        _error -> []
      end

    conn
    |> assign(:content, content)
    |> assign(:events, events)
    |> assign(:latest_news, latest_news)
    |> assign(:page_title, "AEBC Home")
    |> render(:home, layout: {AebcWeb.Layouts, :app_wide})
  end

  def about(conn, _params) do
    single_page("about", :simple, conn)
  end

  def institute(conn, _params) do
    single_page("institute", :simple, conn)
  end

  def download(conn, _params) do
    single_page("download", :simple, conn)
  end

  def hsk(conn, _params) do
    single_page("hsk", :simple, conn)
  end

  def contact_page(conn, _params) do
    single_page("contact-page", :simple, conn)
  end
end
