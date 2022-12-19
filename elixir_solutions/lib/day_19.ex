defmodule Day19 do
  @regexes %{
    ore: ~r/ore robot costs (?<ore>\d+)/,
    clay: ~r/clay robot costs (?<ore>\d+)/,
    obsidian: ~r/obsidian robot costs (?<ore>\d+) ore and (?<clay>\d+) clay/,
    geode: ~r/geode robot costs (?<ore>\d+) ore and (?<obsidian>\d+) obsidian/
  }
  @empty %{ore: 0, clay: 0, obsidian: 0, geode: 0}
  @init_state {MapSet.new([{%{@empty | ore: 1}, @empty}]), %{}, 0}

  def run(path \\ "assets/d19full.txt") do
    parse_input(path)
    |> (&{solution_1(&1), solution_2(&1)}).()
  end

  def parse_input(path) do
    for {line, idx} <-
          File.read!(path)
          |> String.split("\n", trim: true)
          |> Enum.with_index(),
        into: %{},
        do:
          {idx + 1,
           for(
             {key, reg} <- @regexes,
             captures =
               Regex.named_captures(reg, line)
               |> Enum.reduce(%{}, fn {k, v}, acc ->
                 Map.put(acc, String.to_atom(k), String.to_integer(v))
               end),
             into: %{},
             do: {key, captures}
           )}
  end

  def max_costs(blueprint) do
    Enum.reduce(blueprint, %{}, fn {_, costs}, acc ->
      Map.merge(acc, costs, fn _, a, b -> max(a, b) end)
    end)
  end

  def map_sum(map) do
    for {_, v} <- map,
        reduce: 0 do
      acc -> acc + v
    end
  end

  def build_and_harvest(acc, blueprint, max_costs, minute \\ 0, limit \\ 24)
  def build_and_harvest({_, _, max_geodes}, _, _, limit, limit), do: max_geodes

  def build_and_harvest({states, visited, max_geodes}, blueprint, max_costs, minutes, limit) do
    IO.puts("Assessing #{MapSet.size(states)} states")

    Enum.reduce(states, {MapSet.new(), visited, max_geodes}, fn state = {robots, resources},
                                                                {que, seen, geo} ->
      resources_if_wait = Map.merge(robots, resources, fn _, a, b -> a + b end)

      {potential_states, max_geodes} =
        [
          {robots, resources_if_wait}
          | Enum.filter(blueprint, fn {bot, costs} ->
              Enum.all?(costs, fn {resource, cost} ->
                resources[resource] >= cost
              end) &&
                robots[bot] < max_costs[bot]
            end)
            |> Enum.map(fn {bot, costs} ->
              {Map.update(robots, bot, 1, &(&1 + 1)),
               Map.merge(resources, costs, fn _, a, b -> a - b end)
               |> Map.merge(robots, fn
                 :geode, a, b ->
                   a + b

                 r, a, b ->
                   case (limit - minutes) * max_costs[r] do
                     x when x <= a + b -> x
                     _ -> a + b
                   end
               end)}
            end)
        ]
        |> Enum.reduce({que, geo}, fn sub_state = {_, resources}, {q, g} ->
          cond do
            resources[:geode] < max(g - 2, 0) -> {q, g}
            Map.get(seen, sub_state) <= minutes -> {q, g}
            :otherwise -> {MapSet.put(q, sub_state), max(resources[:geode], g)}
          end
        end)

      {potential_states, Map.put(seen, state, minutes), max_geodes}
    end)
    |> build_and_harvest(blueprint, max_costs, minutes + 1, limit)
  end

  def solution_1(blueprints) do
    Task.async_stream(
      blueprints,
      fn {id, blueprint} ->
        id * build_and_harvest(@init_state, blueprint, max_costs(blueprint))
      end,
      timeout: :infinity
    )
    |> Enum.reduce(0, fn
      {:ok, geodes}, acc -> geodes + acc
      _, acc -> acc
    end)
  end

  def solution_2(blueprints) do
    Task.async_stream(
      blueprints,
      fn
        {id, blueprint} when id < 4 ->
          build_and_harvest(@init_state, blueprint, max_costs(blueprint), 0, 32)

        _ ->
          1
      end,
      timeout: :infinity
    )
    |> Enum.reduce(1, fn
      {:ok, geodes}, acc -> acc * geodes
      _, acc -> acc
    end)
  end
end
