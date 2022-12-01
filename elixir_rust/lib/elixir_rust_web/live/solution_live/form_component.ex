defmodule ElixirRustWeb.SolutionLive.FormComponent do
  use ElixirRustWeb, :live_component

  alias ElixirRust.AOC

  @impl true
  def update(%{solution: solution} = assigns, socket) do
    changeset = AOC.change_solution(solution)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"solution" => solution_params}, socket) do
    changeset =
      socket.assigns.solution
      |> AOC.change_solution(solution_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"solution" => solution_params}, socket) do
    save_solution(socket, socket.assigns.action, solution_params)
  end

  defp save_solution(socket, :edit, solution_params) do
    case AOC.update_solution(socket.assigns.solution, solution_params) do
      {:ok, _solution} ->
        {:noreply,
         socket
         |> put_flash(:info, "Solution updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_solution(socket, :new, solution_params) do
    case AOC.create_solution(solution_params) do
      {:ok, _solution} ->
        {:noreply,
         socket
         |> put_flash(:info, "Solution created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
