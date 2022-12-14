defmodule Day14Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d14test.txt"

  test "Solution 1 with small input" do
    assert Day14.parse_input(@test_input)
           |> Day14.solution_1()
           |> (&(&1 == 24)).()
  end

  test "Solution 2 with small input" do
    assert Day14.parse_input(@test_input)
           |> Day14.solution_2()
           |> (&(&1 == 93)).()
  end
end
