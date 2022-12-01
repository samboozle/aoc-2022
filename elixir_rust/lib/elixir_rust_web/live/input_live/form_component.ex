defmodule ElixirRustWeb.InputLive.FormComponent do
  use ElixirRustWeb, :live_component

  alias ElixirRust.AOC

  @impl true
  def update(%{input: input} = assigns, socket) do
    changeset = AOC.change_input(input)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"input" => input_params}, socket) do
    changeset =
      socket.assigns.input
      |> AOC.change_input(input_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"input" => input_params}, socket) do
    save_input(socket, socket.assigns.action, input_params)
  end

  defp save_input(socket, :edit, input_params) do
    case AOC.update_input(socket.assigns.input, input_params) do
      {:ok, _input} ->
        {:noreply,
         socket
         |> put_flash(:info, "Input updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_input(socket, :new, input_params) do
    case AOC.create_input(input_params) do
      {:ok, _input} ->
        {:noreply,
         socket
         |> put_flash(:info, "Input created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
