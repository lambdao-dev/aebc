defmodule AebcWeb.TeacherLiveTest do
  use AebcWeb.ConnCase

  import Phoenix.LiveViewTest
  import Aebc.InstituteFixtures

  @create_attrs %{name: "some name", description: "some description"}
  @update_attrs %{name: "some updated name", description: "some updated description"}
  @invalid_attrs %{name: nil, description: nil}

  defp create_teacher(_) do
    teacher = teacher_fixture()
    %{teacher: teacher}
  end

  describe "Index" do
    setup [:create_teacher]

    test "lists all teachers", %{conn: conn, teacher: teacher} do
      {:ok, _index_live, html} = live(conn, ~p"/teachers")

      assert html =~ "Listing Teachers"
      assert html =~ teacher.name
    end

    test "saves new teacher", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/teachers")

      assert index_live |> element("a", "New Teacher") |> render_click() =~
               "New Teacher"

      assert_patch(index_live, ~p"/teachers/new")

      assert index_live
             |> form("#teacher-form", teacher: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#teacher-form", teacher: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/teachers")

      html = render(index_live)
      assert html =~ "Teacher created successfully"
      assert html =~ "some name"
    end

    test "updates teacher in listing", %{conn: conn, teacher: teacher} do
      {:ok, index_live, _html} = live(conn, ~p"/teachers")

      assert index_live |> element("#teachers-#{teacher.id} a", "Edit") |> render_click() =~
               "Edit Teacher"

      assert_patch(index_live, ~p"/teachers/#{teacher}/edit")

      assert index_live
             |> form("#teacher-form", teacher: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#teacher-form", teacher: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/teachers")

      html = render(index_live)
      assert html =~ "Teacher updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes teacher in listing", %{conn: conn, teacher: teacher} do
      {:ok, index_live, _html} = live(conn, ~p"/teachers")

      assert index_live |> element("#teachers-#{teacher.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#teachers-#{teacher.id}")
    end
  end

  describe "Show" do
    setup [:create_teacher]

    test "displays teacher", %{conn: conn, teacher: teacher} do
      {:ok, _show_live, html} = live(conn, ~p"/teachers/#{teacher}")

      assert html =~ "Show Teacher"
      assert html =~ teacher.name
    end

    test "updates teacher within modal", %{conn: conn, teacher: teacher} do
      {:ok, show_live, _html} = live(conn, ~p"/teachers/#{teacher}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Teacher"

      assert_patch(show_live, ~p"/teachers/#{teacher}/show/edit")

      assert show_live
             |> form("#teacher-form", teacher: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#teacher-form", teacher: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/teachers/#{teacher}")

      html = render(show_live)
      assert html =~ "Teacher updated successfully"
      assert html =~ "some updated name"
    end
  end
end
