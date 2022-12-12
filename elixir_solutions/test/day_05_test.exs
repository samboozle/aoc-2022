defmodule Day05Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d5test.txt"

  test "parses input into [{{int, int}, {int, int}}]" do
    {crates, instructions} = Day05.parse_input(@test_input)

    assert crates
           |> Enum.all?(fn
             {k, v} -> is_integer(k) && Enum.all?(v, &(String.length(&1) == 1))
           end)

    assert instructions
           |> Enum.all?(fn
             three = [a, b, c] -> Enum.all?(three, &is_integer/1)
             _ -> false
           end)
  end

  test "Solution 1 with small input" do
    assert Day05.parse_input(@test_input)
           |> (fn {crates, instructions} -> Day05.solution_1(crates, instructions) end).()
           |> (&(&1 == "CMZ")).()
  end

  test "Solution 2 with small input" do
    assert Day05.parse_input(@test_input)
           |> (fn {crates, instructions} -> Day05.solution_2(crates, instructions) end).()
           |> (&(&1 == "MCD")).()
  end
end
