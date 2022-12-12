defmodule Day11 do
  alias Day11.Monkey

  def run(path \\ "assets/d11full.txt") do
    dir = parse_input(path)
    {solution_1(dir), solution_2(dir)}
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({%{}, 1}, fn {monkey_profile, idx}, {barrel, lcm} ->
      {monkey, divisor} =
        String.split(monkey_profile, "\n", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.reduce({%Monkey{}, 1}, &Monkey.process_profile_line/2)

      {Map.put(barrel, idx, monkey), lcm * divisor}
    end)
  end

  def solution_1({barrel, lcm}), do: simulate_monkey_business(barrel, 20, 3, lcm)

  def solution_2({barrel, lcm}), do: simulate_monkey_business(barrel, 10_000, 1, lcm)

  defp simulate_monkey_business(barrel, 0, _, _) do
    Map.values(barrel)
    |> Enum.sort_by(fn monkey -> monkey.inspections end, :desc)
    |> Enum.take(2)
    |> Enum.reduce(1, fn monkey, acc -> acc * monkey.inspections end)
  end

  defp simulate_monkey_business(barrel, rounds, throttle, lcm) do
    play_round(barrel, lcm, throttle)
    |> simulate_monkey_business(rounds - 1, throttle, lcm)
  end

  defp play_round(barrel, lcm, throttle),
    do: play_round(barrel, lcm, throttle, 0, Enum.count(barrel))

  defp play_round(barrel, _, _, size, size), do: barrel

  defp play_round(barrel, lcm, throttle, idx, size) do
    monkey =
      %Monkey{
        items: items,
        operation: operation,
        test: test,
        targets: {pass, fail}
      } = barrel[idx]

    recipient = fn
      0 -> pass
      _ -> fail
    end

    case :queue.out(items) do
      {{:value, worry}, items} ->
        new_worry = rem(div(operation.(worry), throttle), lcm)

        Map.update!(barrel, idx, fn monk ->
          %Monkey{
            monk
            | items: items,
              inspections: monkey.inspections + 1
          }
        end)
        |> Map.update!(
          recipient.(test.(new_worry)),
          fn monkey ->
            %Monkey{
              monkey
              | items: :queue.in(new_worry, monkey.items)
            }
          end
        )
        |> play_round(lcm, throttle, idx, size)

      {:empty, _} ->
        play_round(barrel, lcm, throttle, idx + 1, size)
    end
  end
end
