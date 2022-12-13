defmodule Day13Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d13test.txt"

  test "Solution 1 with small input" do
    assert Day13.parse_input(@test_input)
           |> Day13.solution_1()
           |> IO.inspect()
           |> (&(&1 == 13)).()
  end

  test "Solution 2 with small input" do
    assert Day13.parse_input(@test_input)
           |> Day13.solution_2()
           |> (&(&1 == 140)).()
  end
end
