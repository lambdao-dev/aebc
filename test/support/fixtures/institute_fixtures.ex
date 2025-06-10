defmodule Aebc.InstituteFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Aebc.Institute` context.
  """

  @doc """
  Generate a teacher.
  """
  def teacher_fixture(attrs \\ %{}) do
    {:ok, teacher} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Aebc.Institute.create_teacher()

    teacher
  end
end
