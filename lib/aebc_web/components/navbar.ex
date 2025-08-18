defmodule AebcWeb.Navbar do
  use Phoenix.Component
  use Gettext, backend: AebcWeb.Gettext
  import AebcWeb.LocaleSelector

  def navbar(assigns) do
    ~H"""
    <header class="bg-white border-b border-zinc-100 px-4 sm:px-6 lg:px-8">
  <div class="flex items-center justify-between py-3 text-sm">
    <!-- Logo -->
    <div class="flex items-center gap-4">
      <a href="/" class="font-bold text-lg">AEBC 比中交流协会</a>
    </div>
    <!-- Hamburger/Close Icon and Checkbox -->
    <div class="lg:hidden flex items-center">
      <input id="navbar-toggle" type="checkbox" class="peer hidden" />
      <label for="navbar-toggle" class="cursor-pointer p-2">
        <!-- Hamburger Icon -->
        <svg class="h-6 w-6 peer-checked:hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M4 6h16M4 12h16M4 18h16"/>
        </svg>
        <!-- Close Icon -->
        <svg class="h-6 w-6 hidden peer-checked:inline-block" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M6 18L18 6M6 6l12 12"/>
        </svg>
      </label>
    </div>
    <!-- Navigation Links -->
    <nav
      class="fixed top-16 left-0 w-full bg-white shadow-lg flex-col items-center gap-4 font-semibold leading-6 text-zinc-900
             max-h-0 overflow-hidden transition-all duration-300
             peer-checked:max-h-96 peer-checked:flex
             lg:static lg:w-auto lg:bg-transparent lg:shadow-none lg:flex lg:flex-row lg:max-h-none lg:overflow-visible"
      id="navbar-menu"
    >
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
    </nav>
  </div>
</header>
    """
  end
end
