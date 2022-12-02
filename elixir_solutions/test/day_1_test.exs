defmodule Day1Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d1test.txt"

  test "parses input into [[integer]]" do
    assert Day1.parse_input(@test_input)
           |> Enum.all?(fn row -> Enum.all?(row, &is_integer/1) end)
  end

  test "Solution 1 with small input" do
    assert Day1.parse_input(@test_input)
           |> Day1.solution_1()
           |> (&(&1 == 24_000)).()
  end

  test "Solution 2 with small input" do
    assert Day1.parse_input(@test_input)
           |> Day1.solution_2()
           |> (&(&1 == 45_000)).()
  end
end
