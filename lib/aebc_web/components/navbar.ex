defmodule AebcWeb.Navbar do
  use Phoenix.Component
  use Gettext, backend: AebcWeb.Gettext
  import AebcWeb.LocaleSelector

  def navbar(assigns) do
    ~H"""
    <header class="bg-white border-b border-zinc-100 px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between py-3 text-sm">
        <div class="flex items-center gap-4">
          <a href="/" class="font-bold text-lg">AEBC 比中交流协会</a>
        </div>

        <div class="nav">
          <input type="checkbox" id="nav-check" />
          <div class="nav-header"></div>
          <div class="nav-btn">
            <label for="nav-check">
              <span></span>
              <span></span>
              <span></span>
            </label>
          </div>

          <div class="nav-links">
            <a href="/about" class="hover:text-zinc-700 block px-4 py-2 lg:p-0">
              {gettext("About")}
            </a>
            <div class="nav-dropdown">
              <span class="nav-dropdown-label">{gettext("Institute")} ▾</span>
              <div class="dropdown-menu">
                <div class="dropdown-menu-inner">
                  <a href="/institute">{gettext("Institute")}</a>
                  <a href="/events">{gettext("Events")}</a>
                  <a href="/administrators">{gettext("Administrators")}</a>
                  <a href="/hsk">{gettext("HSK Centre")}</a>
                </div>
              </div>
            </div>
            <a href="/courses" class="hover:text-zinc-700 block px-4 py-2 lg:p-0">
              {gettext("Courses")}
            </a>
            <a href="/teachers" class="hover:text-zinc-700 block px-4 py-2 lg:p-0">
              {gettext("Teachers")}
            </a>
            <a href="/posts" class="hover:text-zinc-700 block px-4 py-2 lg:p-0">
              {gettext("News")}
            </a>
            <a href="/download" class="hover:text-zinc-700 block px-4 py-2 lg:p-0">
              {gettext("Download")}
            </a>
            <a href="/contact" class="hover:text-zinc-700 block px-4 py-2 lg:p-0">
              {gettext("Contact")}
            </a>
            <.locale_selector />
          </div>
        </div>
      </div>
    </header>
    """
  end
end
