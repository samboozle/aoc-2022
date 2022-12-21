defmodule Day20Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @mini_input "assets/d20mini.txt"
  @test_input "assets/d20test.txt"

  @tag :pending
  test "Solution 1 with small input" do
    assert Day20.parse_input(@test_input)
           |> Day20.solution_1()
           |> (&(&1 == 3)).()
  end

  @tag :pending
  test "Solution 2 with small input" do
    assert Day20.parse_input(@test_input)
           |> Day20.solution_2()
           |> (&(&1 == 1_623_178_306)).()
  end
end
