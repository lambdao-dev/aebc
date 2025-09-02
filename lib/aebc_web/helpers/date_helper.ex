defmodule AebcWeb.DateHelper do
   import Calendar

   def format_date_localized(nil), do: ""

   def format_date_localized(iso_date) do
     with {:ok, datetime, _} <- DateTime.from_iso8601(iso_date) do
       # Get the current locale
       locale = Gettext.get_locale(AebcWeb.Gettext)

       # Extract the English month name
       english_month = Calendar.strftime(datetime, "%B")

       # Translate the month name using the current locale
       translated_month = Gettext.dgettext(AebcWeb.Gettext, "months", english_month)

       # Format the final string with time
       Calendar.strftime(datetime, "%d #{translated_month} %Y, %H:%M")
     else
       _ -> iso_date
     end
   end

   def format_date(nil), do: ""

   def format_date(iso_date) do
     with {:ok, datetime, _} <- DateTime.from_iso8601(iso_date) do
       Calendar.strftime(datetime, "%d/%m/%Y, %H:%M")
     else
       _ -> iso_date
     end
   end
 end
