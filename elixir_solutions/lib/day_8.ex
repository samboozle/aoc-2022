defmodule Day8 do
  def run(path \\ "assets/d8full.txt") do
    dir = parse_input(path)
    {solution_1(dir), solution_2(dir)}
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  def solution_1(forest) do
    len = forest |> Enum.at(0) |> length()

    forward =
      Enum.with_index(forest)
      |> Enum.map(fn {row, idx} -> {Enum.with_index(row), idx} end)

    backward =
      Enum.reverse(forward)
      |> Enum.map(fn {row, idx} -> {Enum.reverse(row), idx} end)

    [forward, backward]
    |> Enum.reduce(MapSet.new(), fn coll, acc ->
      Enum.reduce(coll, with_boundary(acc, len), fn {row, i}, {visible, neighbors} ->
        new_neighbors = Enum.zip_with(row, neighbors, &max(elem(&1, 0), &2))

        {new_vis, _} =
          Enum.zip_reduce(row, neighbors, {visible, 47}, fn
            {tree, j}, _, {vis, max} when tree > max -> {MapSet.put(vis, {i, j}), tree}
            {tree, j}, neighbor, {vis, max} when tree > neighbor -> {MapSet.put(vis, {i, j}), max}
            _, _, acc -> acc
          end)

        {new_vis, new_neighbors}
      end)
      |> elem(0)
    end)
    |> MapSet.size()
  end

  def solution_2(forest) do
    row_end = length(Enum.at(forest, 0)) - 1
    col_end = length(forest) - 1

    height_map =
      Enum.with_index(forest)
      |> Enum.reduce(%{}, fn {row, i}, acc ->
        Enum.with_index(row)
        |> Enum.reduce(acc, fn {tree, j}, acc ->
          Map.put(acc, {i, j}, tree)
        end)
      end)

    for i <- 1..(row_end - 1),
        j <- 1..(col_end - 1),
        tree = height_map[{i, j}] do
      [
        count_until((j - 1)..0, &(tree <= height_map[{i, &1}])),
        count_until((j + 1)..row_end, &(tree <= height_map[{i, &1}])),
        count_until((i - 1)..0, &(tree <= height_map[{&1, j}])),
        count_until((i + 1)..col_end, &(tree <= height_map[{&1, j}]))
      ]
      |> Enum.reduce(1, &Kernel.*/2)
    end
    |> Enum.max()
  end

  defp count_until(list, fun, count \\ 0)

  defp count_until(range, fun, count) when not is_list(range),
    do: Enum.to_list(range) |> count_until(fun, count)

  defp count_until([], _, count), do: count

  defp count_until([head | tail], fun, count) do
    cond do
      fun.(head) -> count + 1
      :otherwise -> count_until(tail, fun, count + 1)
    end
  end

  defp with_boundary(seen, len) do
    boundary = Stream.cycle([47]) |> Enum.take(len)
    {seen, boundary}
  end
end
