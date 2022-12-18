defmodule Day18 do
  def run(path \\ "assets/d18full.txt") do
    parse_input(path)
    |> (&{solution_1(&1), solution_2(&1)}).()
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, ",")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.into(MapSet.new())
  end

  def neighbors([x, y, z]) do
    [
      [x + 1, y, z],
      [x, y + 1, z],
      [x, y, z + 1],
      [x - 1, y, z],
      [x, y - 1, z],
      [x, y, z - 1]
    ]
  end

  def neighbor_split(block, droplet) do
    neighbors(block)
    |> Enum.reduce({MapSet.new(), MapSet.new()}, fn neighbor, {real, fake} ->
      if MapSet.member?(droplet, neighbor) do
        {MapSet.put(real, neighbor), fake}
      else
        {real, MapSet.put(fake, neighbor)}
      end
    end)
  end

  def flood_droplet(_, %MapSet{map: map}, outside, _) when map_size(map) == 0, do: outside

  def flood_droplet(droplet, queue, volume, test) do
    {queue, volume} =
      Enum.reduce(queue, {MapSet.new(), volume}, fn block, {que, vol} ->
        {_, fake} = neighbor_split(block, droplet)

        {MapSet.filter(fake, fn air ->
           test.(air) && not MapSet.member?(volume, air)
         end)
         |> MapSet.union(que), MapSet.put(vol, block)}
      end)

    flood_droplet(droplet, queue, volume, test)
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

  def solution_1(droplet) do
    count_exposed_sides(droplet, &(not MapSet.member?(droplet, &1)))
  end

  def solution_2(droplet) do
    [lo, _, _, _, _, hi] =
      for(
        {x, f} <- [{-1, &Enum.min_by/2}, {1, &Enum.max_by/2}],
        g <- [&Enum.at(&1, 0), &Enum.at(&1, 1), &Enum.at(&1, 2)],
        do: g.(f.(droplet, g)) + x
      )
      |> Enum.sort()

    test = fn block -> Enum.all?(block, &(&1 in lo..hi)) end

    outside = flood_droplet(droplet, MapSet.new([[lo, lo, lo]]), MapSet.new([]), test)

    count_exposed_sides(droplet, fn neighbor ->
      {_, air} = neighbor_split(neighbor, droplet)

      not MapSet.member?(droplet, neighbor) &&
        not MapSet.disjoint?(outside, air)
    end)
  end
end
