defmodule Day17 do
  def run(path \\ "assets/d17full.txt") do
    input = parse_input(path)

    {solution_1(input), solution_2(input)}
  end

  def parse_input(path) do
    File.read!(path)
    |> String.trim()
  end

  def from_shape(:_, h), do: MapSet.new(2..5, &{&1, h})
  def from_shape(:t, h), do: MapSet.new([{2, h + 1}, {3, h + 1}, {4, h + 1}, {3, h + 2}, {3, h}])
  def from_shape(:l, h), do: MapSet.new([{2, h}, {3, h}, {4, h}, {4, h + 1}, {4, h + 2}])
  def from_shape(:i, h), do: MapSet.new(h..(h + 3), &{2, &1})
  def from_shape(:o, h), do: MapSet.new([{2, h}, {3, h}, {2, h + 1}, {3, h + 1}])

  def highest(rock), do: (Enum.max_by(rock, &elem(&1, 1)) |> elem(1)) + 1

  def normalize_rock(rock) do
    min_y = Enum.min_by(rock, &elem(&1, 1)) |> elem(1)
    for {x, y} <- rock, into: MapSet.new(), do: {x, y - min_y}
  end

  def do_moves(rock, chimney, jets, jet_seed) do
    Stream.cycle([0])
    |> Enum.reduce_while({rock, jets}, fn
      _, {rock, ""} ->
        {:cont, {rock, jet_seed}}

      _, {rock, jets} ->
        case do_move(jets, rock, chimney) do
          {:settled, rock, jets} -> {:halt, {rock, jets}}
          {:falling, rock, jets} -> {:cont, {rock, jets}}
        end
    end)
  end

  def do_move(<<jet::utf8, jets::binary>>, rock, chimney) do
    fun = fn
      ?<, k -> k - 1
      ?>, k -> k + 1
    end

    pushed = for {k, v} <- rock, into: MapSet.new(), do: {fun.(jet, k), v}

    rock =
      cond do
        Enum.any?(pushed, fn {k, _} -> k not in 0..6 end) -> rock
        not MapSet.disjoint?(pushed, chimney) -> rock
        :otherwise -> pushed
      end

    fallen = for {k, v} <- rock, into: MapSet.new(), do: {k, v - 1}

    cond do
      Enum.any?(fallen, fn {_, v} -> v < 0 end) -> {:settled, rock, jets}
      not MapSet.disjoint?(fallen, chimney) -> {:settled, rock, jets}
      :otherwise -> {:falling, fallen, jets}
    end
  end

  def tumble_rocks(jet_seed, limit) do
    Stream.cycle([:_, :t, :l, :i, :o])
    |> Enum.reduce_while({MapSet.new(), 0, jet_seed, 0, 0, Map.new(), :queue.new()}, fn
      _, {_, highest, _, ^limit, height_offset, _, _} ->
        {:halt, highest + height_offset}

      shape, {chimney, highest, jets, iter, height_offset, cache, queue} ->
        {rock, jets} =
          from_shape(shape, highest + 3)
          |> do_moves(chimney, jets, jet_seed)

        highest = max(highest(rock), highest)
        chimney = MapSet.union(chimney, rock)
        normal = normalize_rock(rock)

        queue =
          case :queue.len(queue) do
            20 ->
              {_, queue} = :queue.out(queue)
              :queue.in(normal, queue)

            _ ->
              :queue.in(normal, queue)
          end

        state = {queue, jets |> String.length()}

        case Map.get(cache, state) do
          nil ->
            cache = Map.put(cache, state, {highest, 0, iter})
            {:cont, {chimney, highest, jets, iter + 1, height_offset, cache, queue}}

          {height, delta, prev} when highest - height == delta ->
            cycle = iter - prev
            remaining_cycles = div(limit - iter, cycle)
            skipped = cycle * remaining_cycles
            height_offset = height_offset + remaining_cycles * delta

            {:cont, {chimney, highest, jets, iter + skipped + 1, height_offset, Map.new(), queue}}

          {_, _, _} ->
            cache = Map.update!(cache, state, fn {h, _, _} -> {highest, highest - h, iter} end)

            {:cont, {chimney, highest, jets, iter + 1, height_offset, cache, queue}}
        end
    end)
  end

  def solution_1(jet_seed), do: tumble_rocks(jet_seed, 2_022)
  def solution_2(jet_seed), do: tumble_rocks(jet_seed, 1_000_000_000_000)
end
