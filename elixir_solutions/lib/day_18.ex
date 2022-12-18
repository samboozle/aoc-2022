defmodule Day18 do
  def run(path \\ "assets/d18full.txt"),
    do: parse_input(path) |> (&{solution_1(&1), solution_2(&1)}).()

  def parse_input(path) do
    for line <- File.read!(path) |> String.split("\n", trim: true),
        block = String.split(line, ",") |> Enum.map(&String.to_integer/1),
        reduce: {{nil, nil}, MapSet.new()} do
      {{min, max}, droplet} ->
        {{Day15.minish(Enum.min(block) - 1, min), Day15.maxish(Enum.max(block) + 1, max)},
         MapSet.put(droplet, block)}
    end
  end

  def neighbors(block) do
    for i <- [1, -1],
        f <- [
          fn [x, y, z], j -> [x + j, y, z] end,
          fn [x, y, z], j -> [x, y + j, z] end,
          fn [x, y, z], j -> [x, y, z + j] end
        ],
        into: MapSet.new(),
        do: f.(block, i)
  end

  def empties(block, droplet),
    do: MapSet.filter(neighbors(block), &(not MapSet.member?(droplet, &1)))

  def flood_droplet({%MapSet{map: map}, outside}, _, _) when map_size(map) == 0, do: outside

  def flood_droplet({queue, volume}, droplet, test) do
    Enum.reduce(queue, {MapSet.new(), volume}, fn block, {que, vol} ->
      {MapSet.filter(empties(block, droplet), &test.(&1, vol)) |> MapSet.union(que),
       MapSet.put(vol, block)}
    end)
    |> flood_droplet(droplet, test)
  end

  def count_exposed_sides(blocks, test) do
    Enum.reduce(blocks, 0, fn row, acc ->
      for neighbor <- neighbors(row),
          test.(neighbor),
          reduce: acc do
        acc -> acc + 1
      end
    end)
  end

  def solution_1({_, droplet}),
    do: count_exposed_sides(droplet, &(not MapSet.member?(droplet, &1)))

  def solution_2({{lo, hi}, droplet}) do
    outside =
      flood_droplet({MapSet.new([[lo, lo, lo]]), MapSet.new([])}, droplet, fn block, vol ->
        Enum.all?(block, &(&1 in lo..hi)) && not MapSet.member?(vol, block)
      end)

    count_exposed_sides(
      droplet,
      &(not MapSet.member?(droplet, &1) &&
          not MapSet.disjoint?(outside, empties(&1, droplet)))
    )
  end
end
