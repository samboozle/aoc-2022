defmodule Day04Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d4test.txt"

  test "parses input into [{{int, int}, {int, int}}]" do
    assert Day04.parse_input(@test_input)
           |> Enum.all?(fn
             {{_, _}, {_, _}} -> true
             _ -> false
           end)
  end

  test "Solution 1 with small input" do
    assert Day04.parse_input(@test_input)
           |> Day04.solution_1()
           |> (&(&1 == 2)).()
  end

  test "Solution 2 with small input" do
    assert Day04.parse_input(@test_input)
           |> Day04.solution_2()
           |> (&(&1 == 4)).()
  end
end
