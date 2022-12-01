defmodule ElixirRustWeb.PuzzleLiveTest do
  use ElixirRustWeb.ConnCase

  import Phoenix.LiveViewTest
  import ElixirRust.AOCFixtures

  @create_attrs %{day: 42, description: "some description", title: "some title"}
  @update_attrs %{day: 43, description: "some updated description", title: "some updated title"}
  @invalid_attrs %{day: nil, description: nil, title: nil}

  defp create_puzzle(_) do
    puzzle = puzzle_fixture()
    %{puzzle: puzzle}
  end

  describe "Index" do
    setup [:create_puzzle]

    test "lists all puzzles", %{conn: conn, puzzle: puzzle} do
      {:ok, _index_live, html} = live(conn, Routes.puzzle_index_path(conn, :index))

      assert html =~ "Listing Puzzles"
      assert html =~ puzzle.description
    end

    test "saves new puzzle", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.puzzle_index_path(conn, :index))

      assert index_live |> element("a", "New Puzzle") |> render_click() =~
               "New Puzzle"

      assert_patch(index_live, Routes.puzzle_index_path(conn, :new))

      assert index_live
             |> form("#puzzle-form", puzzle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#puzzle-form", puzzle: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.puzzle_index_path(conn, :index))

      assert html =~ "Puzzle created successfully"
      assert html =~ "some description"
    end

    test "updates puzzle in listing", %{conn: conn, puzzle: puzzle} do
      {:ok, index_live, _html} = live(conn, Routes.puzzle_index_path(conn, :index))

      assert index_live |> element("#puzzle-#{puzzle.id} a", "Edit") |> render_click() =~
               "Edit Puzzle"

      assert_patch(index_live, Routes.puzzle_index_path(conn, :edit, puzzle))

      assert index_live
             |> form("#puzzle-form", puzzle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#puzzle-form", puzzle: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.puzzle_index_path(conn, :index))

      assert html =~ "Puzzle updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes puzzle in listing", %{conn: conn, puzzle: puzzle} do
      {:ok, index_live, _html} = live(conn, Routes.puzzle_index_path(conn, :index))

      assert index_live |> element("#puzzle-#{puzzle.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#puzzle-#{puzzle.id}")
    end
  end

  describe "Show" do
    setup [:create_puzzle]

    test "displays puzzle", %{conn: conn, puzzle: puzzle} do
      {:ok, _show_live, html} = live(conn, Routes.puzzle_show_path(conn, :show, puzzle))

      assert html =~ "Show Puzzle"
      assert html =~ puzzle.description
    end

    test "updates puzzle within modal", %{conn: conn, puzzle: puzzle} do
      {:ok, show_live, _html} = live(conn, Routes.puzzle_show_path(conn, :show, puzzle))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Puzzle"

      assert_patch(show_live, Routes.puzzle_show_path(conn, :edit, puzzle))

      assert show_live
             |> form("#puzzle-form", puzzle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#puzzle-form", puzzle: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.puzzle_show_path(conn, :show, puzzle))

      assert html =~ "Puzzle updated successfully"
      assert html =~ "some updated description"
    end
  end
end
