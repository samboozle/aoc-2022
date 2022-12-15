defmodule Day15Test do
  use ExUnit.Case
  doctest ElixirSolutions

  @test_input "assets/d15test.txt"

  test "Solution 1 with small input" do
    {sensors, beacons} = Day15.parse_input(@test_input)

    assert Day15.solution_1(sensors, beacons, 10)
           |> (&(&1 == 26)).()
  end

  test "Solution 2 with small input" do
    {sensors, _} = Day15.parse_input(@test_input)

    assert Day15.solution_2(sensors, 0..20)
           |> (&(&1 == 56_000_011)).()
  end
end
