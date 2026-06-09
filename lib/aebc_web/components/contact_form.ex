defmodule AebcWeb.ContactForm do
  use Phoenix.Component
  use Gettext, backend: AebcWeb.Gettext
  import AebcWeb.CoreComponents

  attr :current_path, :string, required: true
  attr :class, :string, default: nil
  attr :compact, :boolean, default: false
  attr :form_submitted, :boolean, default: false

  def contact_form(assigns) do
    ~H"""
    <div
      id="contact-form-wrapper"
      class={[
        "bg-white rounded-lg shadow-md max-w-88",
        @compact && "p-3",
        !@compact && "mt-8 p-6",
        @class
      ]}
    >
      <h2 class={[
        "font-semibold mb-4",
        @compact && "text-lg",
        !@compact && "text-xl"
      ]}>
        {gettext("Contact Us")}
      </h2>
      <.form
        :let={f}
        for={%{}}
        as={:contact}
        phx-submit="submit_contact"
        id="contact-form"
        class={[
          "space-y-4",
          @compact && "space-y-2"
        ]}
      >
        <input type="hidden" name="contact[state]" value="open" />
        <input type="hidden" name="contact[source_page]" value={@current_path} />
        <input
          type="hidden"
          id="cf-turnstile-response"
          name="contact[cf-turnstile-response]"
          value=""
        />

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
            rows={(@compact && "2") || "4"}
            class={@compact && "text-sm"}
          />
        </div>

        <Turnstile.widget />

        <%= if @form_submitted do %>
          <div class="alert alert-success">
            {gettext("Thank you for your question!")}
          </div>
        <% else %>
          <div>
            <.button
              id="contact-submit-btn"
              type="submit"
              class={"w-full #{if(@compact, do: "py-1 px-3 text-sm", else: "")}"}
            >
              {gettext("Send Question")}
            </.button>
          </div>
        <% end %>
      </.form>
    </div>
    """
  end
end
