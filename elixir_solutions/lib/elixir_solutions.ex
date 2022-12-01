defmodule ElixirSolutions do
  @days %{
    1 => Day1
  }

  def solve(day) do
    case @days[day] do
      nil -> {:error, "No module for day #{day} found"}
      mod -> {:ok, mod.run()}
    end
  end
end
