defmodule AebcWeb.Navbar do
  use Phoenix.Component
  use Gettext, backend: AebcWeb.Gettext
  import AebcWeb.LocaleSelector

  def navbar(assigns) do
    ~H"""
    <header class="px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between border-b border-zinc-100 py-3 text-sm">
        <div class="flex items-center gap-4">
          <a href="/">
            AEBC 比中交流协会
          </a>
          <a href="/about">
            <%= gettext("About") %>
          </a>
          <a href="/institute">
            <%= gettext("Institute") %>
          </a>
          <a href="/directors">
            <%= gettext("Directors") %>
          </a>
        </div>
        <div class="flex items-center gap-4 font-semibold leading-6 text-zinc-900">
          <a href="/events" class="hover:text-zinc-700">
            <%= gettext("Events") %>
          </a>
          <a href="/courses" class="hover:text-zinc-700">
            <%= gettext("Courses") %>
          </a>
          <a href="/teachers" class="hover:text-zinc-700">
            <%= gettext("Teachers") %>
          </a>
          <a href="/posts" class="hover:text-zinc-700">
            <%= gettext("News") %>
          </a>
          <a href="/download" class="hover:text-zinc-700">
            <%= gettext("Download") %>
          </a>
          <a href="/contact" class="hover:text-zinc-700">
            <%= gettext("Contact") %>
          </a>
          <.locale_selector />
        </div>
      </div>
    </header>
    """
  end
end
