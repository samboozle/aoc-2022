defmodule ElixirRustWeb.InputLiveTest do
  use ElixirRustWeb.ConnCase

  import Phoenix.LiveViewTest
  import ElixirRust.AOCFixtures

  @create_attrs %{content: "some content", expected_resulti: "some expected_resulti"}
  @update_attrs %{content: "some updated content", expected_resulti: "some updated expected_resulti"}
  @invalid_attrs %{content: nil, expected_resulti: nil}

  defp create_input(_) do
    input = input_fixture()
    %{input: input}
  end

  describe "Index" do
    setup [:create_input]

    test "lists all inputs", %{conn: conn, input: input} do
      {:ok, _index_live, html} = live(conn, Routes.input_index_path(conn, :index))

      assert html =~ "Listing Inputs"
      assert html =~ input.content
    end

    test "saves new input", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.input_index_path(conn, :index))

      assert index_live |> element("a", "New Input") |> render_click() =~
               "New Input"

      assert_patch(index_live, Routes.input_index_path(conn, :new))

      assert index_live
             |> form("#input-form", input: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#input-form", input: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.input_index_path(conn, :index))

      assert html =~ "Input created successfully"
      assert html =~ "some content"
    end

    test "updates input in listing", %{conn: conn, input: input} do
      {:ok, index_live, _html} = live(conn, Routes.input_index_path(conn, :index))

      assert index_live |> element("#input-#{input.id} a", "Edit") |> render_click() =~
               "Edit Input"

      assert_patch(index_live, Routes.input_index_path(conn, :edit, input))

      assert index_live
             |> form("#input-form", input: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#input-form", input: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.input_index_path(conn, :index))

      assert html =~ "Input updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes input in listing", %{conn: conn, input: input} do
      {:ok, index_live, _html} = live(conn, Routes.input_index_path(conn, :index))

      assert index_live |> element("#input-#{input.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#input-#{input.id}")
    end
  end

  describe "Show" do
    setup [:create_input]

    test "displays input", %{conn: conn, input: input} do
      {:ok, _show_live, html} = live(conn, Routes.input_show_path(conn, :show, input))

      assert html =~ "Show Input"
      assert html =~ input.content
    end

    test "updates input within modal", %{conn: conn, input: input} do
      {:ok, show_live, _html} = live(conn, Routes.input_show_path(conn, :show, input))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Input"

      assert_patch(show_live, Routes.input_show_path(conn, :edit, input))

      assert show_live
             |> form("#input-form", input: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#input-form", input: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.input_show_path(conn, :show, input))

      assert html =~ "Input updated successfully"
      assert html =~ "some updated content"
    end
  end
end
