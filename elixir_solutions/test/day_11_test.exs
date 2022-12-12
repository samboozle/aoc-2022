defmodule Day11Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d11test.txt"

  test "Solution 1 with small input" do
    assert Day11.parse_input(@test_input)
           |> Day11.solution_1()
           |> (&(&1 == 10_605)).()
  end

  test "Solution 2 with small input" do
    assert Day11.parse_input(@test_input)
           |> Day11.solution_2()
           |> (&(&1 == 2_713_310_158)).()
  end
end
