defmodule AebcWeb.ContactForm do
  use Phoenix.Component
  use Gettext, backend: AebcWeb.Gettext
  import AebcWeb.CoreComponents

  attr :current_path, :string, required: true
  attr :class, :string, default: nil
  attr :compact, :boolean, default: false

  def contact_form(assigns) do
    ~H"""
    <div class={[
      "bg-white rounded-lg shadow-md max-w-88",
      @compact && "p-3",
      !@compact && "mt-8 p-6",
      @class
    ]}>
      <h2 class={[
        "font-semibold mb-4",
        @compact && "text-lg",
        !@compact && "text-xl"
      ]}><%= gettext("Contact Us") %></h2>
      <.form
        :let={f}
        for={%{}}
        as={:contact}
        phx-submit="submit_contact"
        class={[
          "space-y-4",
          @compact && "space-y-2"
        ]}
      >
        <input type="hidden" name="contact[state]" value="open" />
        <input type="hidden" name="contact[source_page]" value={@current_path} />

        <div>
          <.input
            field={f[:email]}
            type="email"
            label={gettext("Email")}
            required
            placeholder={gettext("your.email@example.com")}
            class={@compact && "text-sm"}
          />
        </div>

        <div>
          <.input
            field={f[:question]}
            type="textarea"
            label={gettext("Your Question")}
            required
            placeholder={gettext("How can we help you?")}
            rows={@compact && "2" || "4"}
            class={@compact && "text-sm"}
          />
        </div>

        <div>
          <.button type="submit" class={[
            "w-full",
            @compact && "py-1 px-3 text-sm"
          ]}>
            <%= gettext("Send Question") %>
          </.button>
        </div>
      </.form>
    </div>
    """
  end
end
