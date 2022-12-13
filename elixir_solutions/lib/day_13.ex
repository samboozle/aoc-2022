defmodule Day13 do
  def run(path \\ "assets/d13full.txt") do
    input = parse_input(path)
    {solution_1(input), solution_2(input)}
  end

  def parse_input(path) do
    File.read!(path)
    |> String.split("\n\n", trim: true)
    |> Enum.reduce([], fn pair, acc ->
      [
        String.split(pair, "\n", trim: true)
        |> Enum.map(&elem(Code.eval_string(&1), 0))
        | acc
      ]
    end)
    |> Enum.reverse()
  end

  def solution_1(packets) do
    packets
    |> Enum.with_index()
    |> Enum.reduce([], fn {[left, right], idx}, acc ->
      case compare_packet_pair(left, right) do
        true -> [idx + 1 | acc]
        false -> acc
      end
    end)
    |> Enum.sum()
  end

  def solution_2(packets) do
    packets
    |> Enum.reduce([[[2]], [[6]]], fn [a, b], acc -> [a, b | acc] end)
    |> Enum.sort(&compare_packet_pair/2)
    |> Enum.with_index()
    |> Enum.reduce(1, fn
      {[[2]], idx}, acc -> acc * (idx + 1)
      {[[6]], idx}, acc -> acc * (idx + 1)
      _, acc -> acc
    end)
  end

  defp compare_packet_pair([], _), do: true
  defp compare_packet_pair([_ | _], []), do: false

  defp compare_packet_pair([left | ls], [left | rs]),
    do: compare_packet_pair(ls, rs)

  defp compare_packet_pair([left | _], [right | _])
       when is_integer(left) and is_integer(right),
       do: left < right

  defp compare_packet_pair([left | _], [right | _])
       when is_integer(left) and is_list(right),
       do: compare_packet_pair([left], right)

  defp compare_packet_pair([left | _], [right | _])
       when is_list(left) and is_integer(right),
       do: compare_packet_pair(left, [right])

  defp compare_packet_pair([left | _], [right | _])
       when is_list(left) and is_list(right),
       do: compare_packet_pair(left, right)
end
