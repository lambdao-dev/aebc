defmodule Aebc.InstituteTest do
  use Aebc.DataCase

  alias Aebc.Institute

  describe "teachers" do
    alias Aebc.Institute.Teacher

    import Aebc.InstituteFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_teachers/0 returns all teachers" do
      teacher = teacher_fixture()
      assert Institute.list_teachers() == [teacher]
    end

    test "get_teacher!/1 returns the teacher with given id" do
      teacher = teacher_fixture()
      assert Institute.get_teacher!(teacher.id) == teacher
    end

    test "create_teacher/1 with valid data creates a teacher" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Teacher{} = teacher} = Institute.create_teacher(valid_attrs)
      assert teacher.name == "some name"
      assert teacher.description == "some description"
    end

    test "create_teacher/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Institute.create_teacher(@invalid_attrs)
    end

    test "update_teacher/2 with valid data updates the teacher" do
      teacher = teacher_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Teacher{} = teacher} = Institute.update_teacher(teacher, update_attrs)
      assert teacher.name == "some updated name"
      assert teacher.description == "some updated description"
    end

    test "update_teacher/2 with invalid data returns error changeset" do
      teacher = teacher_fixture()
      assert {:error, %Ecto.Changeset{}} = Institute.update_teacher(teacher, @invalid_attrs)
      assert teacher == Institute.get_teacher!(teacher.id)
    end

    test "delete_teacher/1 deletes the teacher" do
      teacher = teacher_fixture()
      assert {:ok, %Teacher{}} = Institute.delete_teacher(teacher)
      assert_raise Ecto.NoResultsError, fn -> Institute.get_teacher!(teacher.id) end
    end

    test "change_teacher/1 returns a teacher changeset" do
      teacher = teacher_fixture()
      assert %Ecto.Changeset{} = Institute.change_teacher(teacher)
    end
  end
end
