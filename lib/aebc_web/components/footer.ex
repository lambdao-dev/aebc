defmodule AebcWeb.Footer do
  use Phoenix.Component
  use Gettext, backend: AebcWeb.Gettext

  def footer(assigns) do
    ~H"""
    <footer class="container mx-auto border-t border-white/20 py-6 px-4 text-sm text-gray-600 md:px-6">
      <div class="flex items-center justify-between">
        <p>
          ©AEBC. <%= gettext("All rights reserved.") %>
        </p>
      </div>
    </footer>
    """
  end
end
