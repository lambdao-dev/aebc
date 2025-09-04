defmodule AebcWeb.DateHelper do
   import Calendar

   def to_brussels(datetime) do
    DateTime.shift_zone(datetime, "Europe/Brussels")
   end

   @spec format_date_localized(nil | binary()) :: binary()
   def format_date_localized(nil), do: ""

   def format_date_localized(iso_date) do
     with {:ok, datetime, _} <- DateTime.from_iso8601(iso_date),
          {:ok, brussels_dt} <- to_brussels(datetime) do
       # Get the current locale
       locale = Gettext.get_locale(AebcWeb.Gettext)

       # Extract the English month name
       english_month = Calendar.strftime(brussels_dt, "%B")

       # Translate the month name using the current locale
       translated_month = Gettext.dgettext(AebcWeb.Gettext, "months", english_month)

       # Format the final string with time
       Calendar.strftime(brussels_dt, "%d #{translated_month} %Y, %H:%M")
     else
       _ -> iso_date
     end
   end

   def format_date(nil), do: ""

   def format_date(iso_date) do
     with {:ok, datetime, _} <- DateTime.from_iso8601(iso_date),
          {:ok, brussels_dt} <- to_brussels(datetime) do
       Calendar.strftime(brussels_dt, "%d/%m/%Y, %H:%M")
     else
       _ -> iso_date
     end
   end
 end
