defmodule ElixirRustWeb.InputLive.Index do
  use ElixirRustWeb, :live_view

  alias ElixirRust.AOC
  alias ElixirRust.AOC.Input

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :inputs, list_inputs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Input")
    |> assign(:input, AOC.get_input!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Input")
    |> assign(:input, %Input{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Inputs")
    |> assign(:input, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    input = AOC.get_input!(id)
    {:ok, _} = AOC.delete_input(input)

    {:noreply, assign(socket, :inputs, list_inputs())}
  end

  defp list_inputs do
    AOC.list_inputs()
  end
end
