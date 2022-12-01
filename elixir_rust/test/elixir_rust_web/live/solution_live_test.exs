defmodule ElixirRustWeb.SolutionLiveTest do
  use ElixirRustWeb.ConnCase

  import Phoenix.LiveViewTest
  import ElixirRust.AOCFixtures

  @create_attrs %{code: "some code", language: "some language"}
  @update_attrs %{code: "some updated code", language: "some updated language"}
  @invalid_attrs %{code: nil, language: nil}

  defp create_solution(_) do
    solution = solution_fixture()
    %{solution: solution}
  end

  describe "Index" do
    setup [:create_solution]

    test "lists all solutions", %{conn: conn, solution: solution} do
      {:ok, _index_live, html} = live(conn, Routes.solution_index_path(conn, :index))

      assert html =~ "Listing Solutions"
      assert html =~ solution.code
    end

    test "saves new solution", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.solution_index_path(conn, :index))

      assert index_live |> element("a", "New Solution") |> render_click() =~
               "New Solution"

      assert_patch(index_live, Routes.solution_index_path(conn, :new))

      assert index_live
             |> form("#solution-form", solution: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#solution-form", solution: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.solution_index_path(conn, :index))

      assert html =~ "Solution created successfully"
      assert html =~ "some code"
    end

    test "updates solution in listing", %{conn: conn, solution: solution} do
      {:ok, index_live, _html} = live(conn, Routes.solution_index_path(conn, :index))

      assert index_live |> element("#solution-#{solution.id} a", "Edit") |> render_click() =~
               "Edit Solution"

      assert_patch(index_live, Routes.solution_index_path(conn, :edit, solution))

      assert index_live
             |> form("#solution-form", solution: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#solution-form", solution: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.solution_index_path(conn, :index))

      assert html =~ "Solution updated successfully"
      assert html =~ "some updated code"
    end

    test "deletes solution in listing", %{conn: conn, solution: solution} do
      {:ok, index_live, _html} = live(conn, Routes.solution_index_path(conn, :index))

      assert index_live |> element("#solution-#{solution.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#solution-#{solution.id}")
    end
  end

  describe "Show" do
    setup [:create_solution]

    test "displays solution", %{conn: conn, solution: solution} do
      {:ok, _show_live, html} = live(conn, Routes.solution_show_path(conn, :show, solution))

      assert html =~ "Show Solution"
      assert html =~ solution.code
    end

    test "updates solution within modal", %{conn: conn, solution: solution} do
      {:ok, show_live, _html} = live(conn, Routes.solution_show_path(conn, :show, solution))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Solution"

      assert_patch(show_live, Routes.solution_show_path(conn, :edit, solution))

      assert show_live
             |> form("#solution-form", solution: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#solution-form", solution: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.solution_show_path(conn, :show, solution))

      assert html =~ "Solution updated successfully"
      assert html =~ "some updated code"
    end
  end
end
