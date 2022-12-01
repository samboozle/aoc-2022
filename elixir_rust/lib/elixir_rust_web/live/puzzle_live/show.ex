defmodule ElixirRustWeb.PuzzleLive.Show do
  use ElixirRustWeb, :live_view

  alias ElixirRust.AOC

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:puzzle, AOC.get_puzzle!(id))}
  end

  defp page_title(:show), do: "Show Puzzle"
  defp page_title(:edit), do: "Edit Puzzle"
end
