defmodule Aebc.Institute.Teacher do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teachers" do
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(teacher, attrs) do
    teacher
    |> cast(attrs, [:description, :name])
    |> validate_required([:description, :name])
  end
end
