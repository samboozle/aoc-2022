defmodule ElixirRust.AOCTest do
  use ElixirRust.DataCase

  alias ElixirRust.AOC

  describe "puzzles" do
    alias ElixirRust.AOC.Puzzle

    import ElixirRust.AOCFixtures

    @invalid_attrs %{day: nil, description: nil, title: nil}

    test "list_puzzles/0 returns all puzzles" do
      puzzle = puzzle_fixture()
      assert AOC.list_puzzles() == [puzzle]
    end

    test "get_puzzle!/1 returns the puzzle with given id" do
      puzzle = puzzle_fixture()
      assert AOC.get_puzzle!(puzzle.id) == puzzle
    end

    test "create_puzzle/1 with valid data creates a puzzle" do
      valid_attrs = %{day: 42, description: "some description", title: "some title"}

      assert {:ok, %Puzzle{} = puzzle} = AOC.create_puzzle(valid_attrs)
      assert puzzle.day == 42
      assert puzzle.description == "some description"
      assert puzzle.title == "some title"
    end

    test "create_puzzle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AOC.create_puzzle(@invalid_attrs)
    end

    test "update_puzzle/2 with valid data updates the puzzle" do
      puzzle = puzzle_fixture()
      update_attrs = %{day: 43, description: "some updated description", title: "some updated title"}

      assert {:ok, %Puzzle{} = puzzle} = AOC.update_puzzle(puzzle, update_attrs)
      assert puzzle.day == 43
      assert puzzle.description == "some updated description"
      assert puzzle.title == "some updated title"
    end

    test "update_puzzle/2 with invalid data returns error changeset" do
      puzzle = puzzle_fixture()
      assert {:error, %Ecto.Changeset{}} = AOC.update_puzzle(puzzle, @invalid_attrs)
      assert puzzle == AOC.get_puzzle!(puzzle.id)
    end

    test "delete_puzzle/1 deletes the puzzle" do
      puzzle = puzzle_fixture()
      assert {:ok, %Puzzle{}} = AOC.delete_puzzle(puzzle)
      assert_raise Ecto.NoResultsError, fn -> AOC.get_puzzle!(puzzle.id) end
    end

    test "change_puzzle/1 returns a puzzle changeset" do
      puzzle = puzzle_fixture()
      assert %Ecto.Changeset{} = AOC.change_puzzle(puzzle)
    end
  end

  describe "inputs" do
    alias ElixirRust.AOC.Input

    import ElixirRust.AOCFixtures

    @invalid_attrs %{content: nil, expected_resulti: nil}

    test "list_inputs/0 returns all inputs" do
      input = input_fixture()
      assert AOC.list_inputs() == [input]
    end

    test "get_input!/1 returns the input with given id" do
      input = input_fixture()
      assert AOC.get_input!(input.id) == input
    end

    test "create_input/1 with valid data creates a input" do
      valid_attrs = %{content: "some content", expected_resulti: "some expected_resulti"}

      assert {:ok, %Input{} = input} = AOC.create_input(valid_attrs)
      assert input.content == "some content"
      assert input.expected_resulti == "some expected_resulti"
    end

    test "create_input/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AOC.create_input(@invalid_attrs)
    end

    test "update_input/2 with valid data updates the input" do
      input = input_fixture()
      update_attrs = %{content: "some updated content", expected_resulti: "some updated expected_resulti"}

      assert {:ok, %Input{} = input} = AOC.update_input(input, update_attrs)
      assert input.content == "some updated content"
      assert input.expected_resulti == "some updated expected_resulti"
    end

    test "update_input/2 with invalid data returns error changeset" do
      input = input_fixture()
      assert {:error, %Ecto.Changeset{}} = AOC.update_input(input, @invalid_attrs)
      assert input == AOC.get_input!(input.id)
    end

    test "delete_input/1 deletes the input" do
      input = input_fixture()
      assert {:ok, %Input{}} = AOC.delete_input(input)
      assert_raise Ecto.NoResultsError, fn -> AOC.get_input!(input.id) end
    end

    test "change_input/1 returns a input changeset" do
      input = input_fixture()
      assert %Ecto.Changeset{} = AOC.change_input(input)
    end
  end

  describe "solutions" do
    alias ElixirRust.AOC.Solution

    import ElixirRust.AOCFixtures

    @invalid_attrs %{code: nil, language: nil}

    test "list_solutions/0 returns all solutions" do
      solution = solution_fixture()
      assert AOC.list_solutions() == [solution]
    end

    test "get_solution!/1 returns the solution with given id" do
      solution = solution_fixture()
      assert AOC.get_solution!(solution.id) == solution
    end

    test "create_solution/1 with valid data creates a solution" do
      valid_attrs = %{code: "some code", language: "some language"}

      assert {:ok, %Solution{} = solution} = AOC.create_solution(valid_attrs)
      assert solution.code == "some code"
      assert solution.language == "some language"
    end

    test "create_solution/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AOC.create_solution(@invalid_attrs)
    end

    test "update_solution/2 with valid data updates the solution" do
      solution = solution_fixture()
      update_attrs = %{code: "some updated code", language: "some updated language"}

      assert {:ok, %Solution{} = solution} = AOC.update_solution(solution, update_attrs)
      assert solution.code == "some updated code"
      assert solution.language == "some updated language"
    end

    test "update_solution/2 with invalid data returns error changeset" do
      solution = solution_fixture()
      assert {:error, %Ecto.Changeset{}} = AOC.update_solution(solution, @invalid_attrs)
      assert solution == AOC.get_solution!(solution.id)
    end

    test "delete_solution/1 deletes the solution" do
      solution = solution_fixture()
      assert {:ok, %Solution{}} = AOC.delete_solution(solution)
      assert_raise Ecto.NoResultsError, fn -> AOC.get_solution!(solution.id) end
    end

    test "change_solution/1 returns a solution changeset" do
      solution = solution_fixture()
      assert %Ecto.Changeset{} = AOC.change_solution(solution)
    end
  end
end
