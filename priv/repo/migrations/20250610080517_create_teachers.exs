defmodule Aebc.Repo.Migrations.CreateTeachers do
  use Ecto.Migration

  def change do
    create table(:teachers) do
      add :description, :text
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
