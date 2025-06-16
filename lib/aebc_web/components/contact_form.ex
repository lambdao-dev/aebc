defmodule AebcWeb.ContactForm do
  use Phoenix.Component
  use Gettext, backend: AebcWeb.Gettext
  import AebcWeb.CoreComponents

  attr :current_path, :string, required: true
  attr :class, :string, default: nil

  def contact_form(assigns) do
    ~H"""
    <div class={["mt-8 p-6 bg-white rounded-lg shadow-md max-w-88", @class]}>
      <h2 class="text-xl font-semibold mb-4"><%= gettext("Contact Us") %></h2>
      <.form
        :let={f}
        for={%{}}
        as={:contact}
        phx-submit="submit_contact"
        class="space-y-4"
      >
        <input type="hidden" name="contact[state]" value="open" />
        <input type="hidden" name="contact[page]" value={@current_path} />

        <div>
          <.input
            field={f[:email]}
            type="email"
            label={gettext("Email")}
            required
            placeholder={gettext("your.email@example.com")}
          />
        </div>

        <div>
          <.input
            field={f[:question]}
            type="textarea"
            label={gettext("Your Question")}
            required
            placeholder={gettext("How can we help you?")}
            rows="4"
          />
        </div>

        <div>
          <.button type="submit" class="w-full">
            <%= gettext("Send Question") %>
          </.button>
        </div>
      </.form>
    </div>
    """
  end
end
