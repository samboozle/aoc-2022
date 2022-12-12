defmodule Day09Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d8test.txt"

  @tag :pending
  test "Solution 1 with small input" do
    assert Day09.parse_input(@test_input)
           |> Day09.solution_1()
           |> (&(&1 == 21)).()
  end

  @tag :pending
  test "Solution 2 with small input" do
    assert Day09.parse_input(@test_input)
           |> Day09.solution_2()
           |> (&(&1 == 8)).()
  end
end
