defmodule ElixirRustWeb.PuzzleLive.Index do
  use ElixirRustWeb, :live_view

  alias ElixirRust.AOC
  alias ElixirRust.AOC.Puzzle

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :puzzles, list_puzzles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Puzzle")
    |> assign(:puzzle, AOC.get_puzzle!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Puzzle")
    |> assign(:puzzle, %Puzzle{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Puzzles")
    |> assign(:puzzle, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    puzzle = AOC.get_puzzle!(id)
    {:ok, _} = AOC.delete_puzzle(puzzle)

    {:noreply, assign(socket, :puzzles, list_puzzles())}
  end

  defp list_puzzles do
    AOC.list_puzzles()
  end
end
