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

  def single_page(name, template, conn, _params) do
    locale = Gettext.get_locale(AebcWeb.Gettext)
    {status, resp} = Institute.fetch_single_page(name, locale)
    content = case status do
      :ok -> resp
      _error -> nil
    end
    conn
    |> assign(:content, content)
    |> render(template)
  end

  def home(conn, _params) do
    single_page("home", :home, conn, _params)
  end

  def about(conn, _params) do  # TODO
    single_page("about", :simple, conn, _params)
  end

  def institute(conn, _params) do  # TODO
    single_page("institute", :simple, conn, _params)
  end

  def download(conn, _params) do  # TODO
    single_page("download", :simple, conn, _params)
  end
end
