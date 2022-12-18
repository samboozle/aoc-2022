defmodule Day18Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @mini_input "assets/d18mini.txt"
  @test_input "assets/d18test.txt"

  test "Solution 1 with mini input" do
    assert Day18.parse_input(@mini_input)
           |> Day18.solution_1()
           |> (&(&1 == 10)).()
  end

  test "Solution 1 with small input" do
    assert Day18.parse_input(@test_input)
           |> Day18.solution_1()
           |> (&(&1 == 64)).()
  end

  test "Solution 2 with small input" do
    assert Day18.parse_input(@test_input)
           |> Day18.solution_2()
           |> (&(&1 == 58)).()
  end
end
