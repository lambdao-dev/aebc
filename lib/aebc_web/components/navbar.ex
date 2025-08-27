defmodule AebcWeb.Navbar do
  use Phoenix.Component
  use Gettext, backend: AebcWeb.Gettext
  import AebcWeb.LocaleSelector

  def navbar(assigns) do
    ~H"""
    <header class="bg-white border-b border-zinc-100 px-4 sm:px-6 lg:px-8">
    <div class="nav">
  <input type="checkbox" id="nav-check">
  <div class="nav-header">
  </div>
  <div class="nav-btn">
    <label for="nav-check">
      <span></span>
      <span></span>
      <span></span>
    </label>
  </div>
  <div class="nav-links">
  <a href="/about" class="hover:text-zinc-700 block px-4 py-2 lg:p-0"><%=gettext("About")%></a>
      <a href="/institute" class="hover:text-zinc-700 block px-4 py-2 lg:p-0"><%=gettext("Institute")%></a>
      <a href="/directors" class="hover:text-zinc-700 block px-4 py-2 lg:p-0"><%=gettext("Directors")%></a>
      <a href="/events" class="hover:text-zinc-700 block px-4 py-2 lg:p-0"><%=gettext("Events")%></a>
      <a href="/courses" class="hover:text-zinc-700 block px-4 py-2 lg:p-0"><%=gettext("Courses")%></a>
      <a href="/teachers" class="hover:text-zinc-700 block px-4 py-2 lg:p-0"><%=gettext("Teachers")%></a>
      <a href="/posts" class="hover:text-zinc-700 block px-4 py-2 lg:p-0"><%=gettext("News")%></a>
      <a href="/download" class="hover:text-zinc-700 block px-4 py-2 lg:p-0"><%=gettext("Download")%></a>
      <a href="/contact" class="hover:text-zinc-700 block px-4 py-2 lg:p-0"><%=gettext("Contact")%></a>
      <.locale_selector />
  </div>
</div>
</header>
    """
  end
end
