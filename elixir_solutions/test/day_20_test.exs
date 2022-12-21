defmodule Day19Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @mini_input "assets/d19mini.txt"
  @test_input "assets/d19test.txt"

  test "Solution 1 with small input" do
    assert Day19.parse_input(@test_input)
           |> Day19.solution_1()
           |> (&(&1 == 3)).()
  end

  @tag :pending
  test "Solution 2 with small input" do
    assert Day19.parse_input(@test_input)
           |> Day19.solution_2()
           |> (&(&1 == 1_623_178_306)).()
  end
end
