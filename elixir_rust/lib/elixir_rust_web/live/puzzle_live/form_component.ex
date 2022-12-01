defmodule ElixirRustWeb.PuzzleLive.FormComponent do
  use ElixirRustWeb, :live_component

  alias ElixirRust.AOC

  @impl true
  def update(%{puzzle: puzzle} = assigns, socket) do
    changeset = AOC.change_puzzle(puzzle)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"puzzle" => puzzle_params}, socket) do
    changeset =
      socket.assigns.puzzle
      |> AOC.change_puzzle(puzzle_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"puzzle" => puzzle_params}, socket) do
    save_puzzle(socket, socket.assigns.action, puzzle_params)
  end

  defp save_puzzle(socket, :edit, puzzle_params) do
    case AOC.update_puzzle(socket.assigns.puzzle, puzzle_params) do
      {:ok, _puzzle} ->
        {:noreply,
         socket
         |> put_flash(:info, "Puzzle updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_puzzle(socket, :new, puzzle_params) do
    case AOC.create_puzzle(puzzle_params) do
      {:ok, _puzzle} ->
        {:noreply,
         socket
         |> put_flash(:info, "Puzzle created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
