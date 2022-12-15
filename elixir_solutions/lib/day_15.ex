defmodule Day15 do
  @sensor_beacon ~r/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/

  def run(path \\ "assets/d15full.txt") do
    {sensors, beacons} = parse_input(path)

    {
      solution_1(sensors, beacons, 2_000_000),
      solution_2(sensors, 0..4_000_000)
      # old_solution_2(input, 0..4_000_000)
    }
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, MapSet.new()}, fn line, {sensors_beacons, beacons} ->
      [sx, sy, bx, by] =
        Regex.run(@sensor_beacon, line)
        |> Enum.drop(1)
        |> Enum.map(&String.to_integer/1)

      {
        Map.put(sensors_beacons, {sx, sy}, manhattan({sx, sy}, {bx, by})),
        MapSet.put(beacons, {bx, by})
      }
    end)
  end

  defp manhattan({a, b}, {x, y}), do: abs(a - x) + abs(b - y)

  # For a given row, find the coverage width of all sensors
  def solution_1(coords, beacons, row) do
    find_empty_spots(coords, row)
    # Remove number of known beacons
    |> (fn width ->
          width -
            Enum.count(beacons, fn
              {_, ^row} -> true
              _ -> false
            end)
        end).()
  end

  defp find_empty_spots(coords, row) do
    Enum.reduce(coords, {nil, nil}, fn {{sx, sy}, manhattan}, width = {mn, mx} ->
      case manhattan - abs(row - sy) do
        x when x > 0 -> {minish(sx - x, mn), maxish(sx + x, mx)}
        _ -> width
      end
    end)
    |> (fn {x, y} -> y - x + 1 end).()
  end

  defp minish(x, nil), do: x
  defp minish(x, y), do: min(x, y)
  defp maxish(x, nil), do: x
  defp maxish(x, y), do: max(x, y)

  # Inspired by (read: stolen from) u/SLiV9
  # https://github.com/SLiV9/AdventOfCode2022/blob/main/src/bin/day15/main.rs
  def solution_2(coords, limits) do
    [asc, desc] =
      Enum.map([&Kernel.-/2, &Kernel.+/2], fn operator ->
        Enum.reduce(coords, [], fn {_sensor = {x, y}, manhattan}, acc ->
          [
            operator.(x + manhattan + 1, y),
            operator.(x - manhattan - 1, y)
            | acc
          ]
        end)
        |> Enum.sort()
        |> Enum.chunk_every(2, 1)
        |> Enum.reduce(MapSet.new(), fn
          [a, a], dupes -> MapSet.put(dupes, a)
          _, dupes -> dupes
        end)
      end)

    for(
      a <- asc,
      d <- desc,
      k = div(d - a, 2),
      point = {x, y} = {a + k, k},
      x in limits,
      y in limits,
      not Enum.any?(coords, fn {sensor, range} -> manhattan(sensor, point) <= range end),
      do: point
    )
    |> case do
      [{x, y}] -> x * 4_000_000 + y
      _ -> :error
    end
  end

  # Unoptimized solution looking for windows on a given row
  def old_solution_2(coords, limits) do
    Enum.reduce_while(limits, nil, fn row, _ ->
      case find_empty_spots_between(coords, limits, row) do
        {:found, {x, y}} -> {:halt, x * 4_000_000 + y}
        # {:found, {x, y}} -> {:halt, {x, y}}
        _ -> {:cont, nil}
      end
    end)
  end

  # Performed for each row between 0 and 4_000_000
  defp find_empty_spots_between(coords, limits, row) do
    Enum.reduce(coords, [], fn {{sx, sy}, manhattan}, acc ->
      case manhattan - abs(row - sy) do
        x when x > 0 -> [{sx - x, sx + x} | acc]
        _ -> acc
      end
    end)
    |> Enum.sort_by(fn {x, _} -> x end)
    |> Enum.reduce_while(nil, fn
      y, nil ->
        {:cont, y}

      curr = {x, _}, prev = {_, b} ->
        cond do
          x > b && (x - 1) in limits -> {:halt, {:found, {x - 1, row}}}
          :otherwise -> {:cont, Enum.max_by([prev, curr], fn {_, v} -> v end)}
        end
    end)
  end
end
