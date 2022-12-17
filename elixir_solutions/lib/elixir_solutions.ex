defmodule ElixirSolutions do
  @days %{
    1 => Day01,
    2 => Day02,
    3 => Day03,
    4 => Day04,
    5 => Day05,
    6 => Day06,
    7 => Day07,
    8 => Day08,
    # 9 => Day09,
    # 10 => Day10,
    11 => Day11,
    12 => Day12,
    13 => Day13,
    14 => Day14,
    15 => Day15,
    16 => Day16,
    17 => Day17
  }

  def solve(day) do
    case @days[day] do
      nil -> {:error, "No module for day #{day} found"}
      mod -> {:ok, mod.run()}
    end
  end

  def solutions, do: for(day <- 1..25, do: solve(day))
end
