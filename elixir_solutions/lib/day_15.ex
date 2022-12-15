defmodule Day15 do
  @sensor_beacon ~r/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/

  def run(path \\ "assets/d15full.txt") do
    input = parse_input(path)
    {solution_1(input, 2_000_000), solution_2(input, {0, 4_000_000})}
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, MapSet.new(), MapSet.new()}, fn line, {sens_beac, sensors, beacons} ->
      [s_x, s_y, b_x, b_y] =
        Regex.run(@sensor_beacon, line)
        |> Enum.drop(1)
        |> Enum.map(&String.to_integer/1)

      {
        Map.put(sens_beac, {s_x, s_y}, {b_x, b_y}),
        MapSet.put(sensors, {s_x, s_y}),
        MapSet.put(beacons, {b_x, b_y})
      }
    end)
  end

  def solution_1({coords, _, beacons}, row) do
    {lo, hi} = find_empty_spots(coords, row)
    hi - lo + 1 - Enum.count(beacons, fn {_, y} -> y == row end)
  end

  def solution_2({coords, _, _}, window = {x, y}) do
    find_empty_spots_between(coords, window, 11)

    Enum.reduce_while(x..y, nil, fn row, _ ->
      case find_empty_spots_between(coords, window, row) do
        {:found, {x, y}} -> {:halt, x * 4_000_000 + y}
        _ -> {:cont, nil}
      end
    end)
  end

  defp find_empty_spots(coords, row) do
    Enum.reduce(coords, {nil, nil}, fn {{sx, sy}, {bx, by}}, width = {mn, mx} ->
      del_x = abs(sx - bx)
      del_y = abs(sy - by)
      manhattan = del_x + del_y

      case manhattan - abs(row - sy) do
        x when x > 0 -> {minish(sx - x, mn), maxish(sx + x, mx)}
        _ -> width
      end
    end)
  end

  defp find_empty_spots_between(coords, {lo, hi}, row) do
    Enum.reduce(coords, [], fn {{sx, sy}, {bx, by}}, acc ->
      # Enum.reduce(coords, [{lo - 2, row}, {hi + 2, row}], fn {{sx, sy}, {bx, by}}, acc ->
      del_x = abs(sx - bx)
      del_y = abs(sy - by)
      manhattan = del_x + del_y

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
          x > b && (x - 1) in lo..hi -> {:halt, {:found, {x - 1, row}}}
          :otherwise -> {:cont, Enum.max_by([prev, curr], fn {_, v} -> v end)}
        end
    end)
  end

  defp minish(x, nil), do: x
  defp minish(x, y), do: min(x, y)
  defp maxish(x, nil), do: x
  defp maxish(x, y), do: max(x, y)
end
