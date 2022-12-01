defmodule ElixirRust.AOCFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirRust.AOC` context.
  """

  @doc """
  Generate a puzzle.
  """
  def puzzle_fixture(attrs \\ %{}) do
    {:ok, puzzle} =
      attrs
      |> Enum.into(%{
        day: 42,
        description: "some description",
        title: "some title"
      })
      |> ElixirRust.AOC.create_puzzle()

    puzzle
  end

  @doc """
  Generate a input.
  """
  def input_fixture(attrs \\ %{}) do
    {:ok, input} =
      attrs
      |> Enum.into(%{
        content: "some content",
        expected_resulti: "some expected_resulti"
      })
      |> ElixirRust.AOC.create_input()

    input
  end

  @doc """
  Generate a solution.
  """
  def solution_fixture(attrs \\ %{}) do
    {:ok, solution} =
      attrs
      |> Enum.into(%{
        code: "some code",
        language: "some language"
      })
      |> ElixirRust.AOC.create_solution()

    solution
  end
end
