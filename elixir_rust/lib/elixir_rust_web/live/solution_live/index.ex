defmodule ElixirRustWeb.SolutionLive.Index do
  use ElixirRustWeb, :live_view

  alias ElixirRust.AOC
  alias ElixirRust.AOC.Solution

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :solutions, list_solutions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Solution")
    |> assign(:solution, AOC.get_solution!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Solution")
    |> assign(:solution, %Solution{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Solutions")
    |> assign(:solution, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    solution = AOC.get_solution!(id)
    {:ok, _} = AOC.delete_solution(solution)

    {:noreply, assign(socket, :solutions, list_solutions())}
  end

  defp list_solutions do
    AOC.list_solutions()
  end
end
