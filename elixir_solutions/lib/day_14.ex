defmodule Day14 do
  def run(path \\ "assets/d14full.txt") do
    input = parse_input(path)
    {solution_1(input), solution_2(input)}
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.reduce(MapSet.new(), fn line, acc ->
      String.split(line, " -> ")
      |> Enum.map(fn coord -> String.split(coord, ",") |> Enum.map(&String.to_integer/1) end)
      |> Enum.chunk_every(2, 1)
      |> Enum.reduce(acc, fn
        [[a, b], [a, c]], acc ->
          for(
            x <- b..c,
            into: %MapSet{},
            do: {a, x}
          )
          |> MapSet.union(acc)

        [[a, c], [b, c]], acc ->
          for(
            x <- a..b,
            into: %MapSet{},
            do: {x, c}
          )
          |> MapSet.union(acc)

        _, acc ->
          acc
      end)
    end)
  end

  def solution_1(blocked) do
    {_, ground} = Enum.max_by(blocked, fn {_, y} -> y end)
    drop_sand(blocked, ground)
  end

  def solution_2(blocked) do
    {_, ground} = Enum.max_by(blocked, fn {_, y} -> y end)
    drop_sand(blocked, ground + 2, :floor)
  end

  defp drop_sand(blocked, ground, flag \\ :void, grains \\ 0, terminated \\ false)
  defp drop_sand(_, _, _, grains, true), do: grains

  defp drop_sand(blocked, ground, flag, grains, _) do
    case settle_sand(blocked, ground, {500, 0}, flag) do
      :done -> grains
      blocked -> drop_sand(blocked, ground, flag, grains + 1, MapSet.member?(blocked, {500, 0}))
    end
  end

  defp settle_sand(_, ground, {_, ground}, :void), do: :done

  defp settle_sand(blocked, ground, {x, y}, flag) do
    [{x - 1, y + 1}, {x, y + 1}, {x + 1, y + 1}]
    |> Enum.map(&blocked?(&1, blocked, ground, flag))
    |> case do
      [_, false, _] ->
        settle_sand(blocked, ground, {x, y + 1}, flag)

      [false, _, _] ->
        settle_sand(blocked, ground, {x - 1, y + 1}, flag)

      [_, _, false] ->
        settle_sand(blocked, ground, {x + 1, y + 1}, flag)

      [true, true, true] ->
        MapSet.put(blocked, {x, y})
    end
  end

  defp blocked?({_, ground}, _, ground, :floor), do: true
  defp blocked?(coord, set, _, _), do: MapSet.member?(set, coord)
end
