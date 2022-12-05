defmodule ElixirSolutions do
  @days %{
    1 => Day1,
    2 => Day2,
    3 => Day3,
    4 => Day4,
    5 => Day5
  }

  def solve(day) do
    case @days[day] do
      nil -> {:error, "No module for day #{day} found"}
      mod -> {:ok, mod.run()}
    end
  end

  def solutions, do: for(day <- 1..25, do: solve(day))
end
