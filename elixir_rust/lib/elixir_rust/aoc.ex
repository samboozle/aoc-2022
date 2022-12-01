defmodule ElixirRust.AOC do
  @moduledoc """
  The AOC context.
  """

  import Ecto.Query, warn: false
  alias ElixirRust.Repo
  alias ElixirRust.AOC.{Puzzle, Input, Solution}

  @doc """
  Returns the list of puzzles.

  ## Examples

      iex> list_puzzles()
      [%Puzzle{}, ...]

  """
  def list_puzzles do
    Repo.all(Puzzle)
  end

  @doc """
  Gets a single puzzle.

  Raises `Ecto.NoResultsError` if the Puzzle does not exist.

  ## Examples

      iex> get_puzzle!(123)
      %Puzzle{}

      iex> get_puzzle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_puzzle!(id), do: Repo.get!(Puzzle, id)

  @doc """
  Creates a puzzle.

  ## Examples

      iex> create_puzzle(%{field: value})
      {:ok, %Puzzle{}}

      iex> create_puzzle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_puzzle(attrs \\ %{}) do
    %Puzzle{}
    |> Puzzle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a puzzle.

  ## Examples

      iex> update_puzzle(puzzle, %{field: new_value})
      {:ok, %Puzzle{}}

      iex> update_puzzle(puzzle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_puzzle(%Puzzle{} = puzzle, attrs) do
    puzzle
    |> Puzzle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a puzzle.

  ## Examples

      iex> delete_puzzle(puzzle)
      {:ok, %Puzzle{}}

      iex> delete_puzzle(puzzle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_puzzle(%Puzzle{} = puzzle) do
    Repo.delete(puzzle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking puzzle changes.

  ## Examples

      iex> change_puzzle(puzzle)
      %Ecto.Changeset{data: %Puzzle{}}

  """
  def change_puzzle(%Puzzle{} = puzzle, attrs \\ %{}) do
    Puzzle.changeset(puzzle, attrs)
  end

  @doc """
  Returns the list of inputs.

  ## Examples

      iex> list_inputs()
      [%Input{}, ...]

  """
  def list_inputs do
    Repo.all(Input)
  end

  @doc """
  Gets a single input.

  Raises `Ecto.NoResultsError` if the Input does not exist.

  ## Examples

      iex> get_input!(123)
      %Input{}

      iex> get_input!(456)
      ** (Ecto.NoResultsError)

  """
  def get_input!(id), do: Repo.get!(Input, id)

  @doc """
  Creates a input.

  ## Examples

      iex> create_input(%{field: value})
      {:ok, %Input{}}

      iex> create_input(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_input(attrs \\ %{}) do
    %Input{}
    |> Input.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a input.

  ## Examples

      iex> update_input(input, %{field: new_value})
      {:ok, %Input{}}

      iex> update_input(input, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_input(%Input{} = input, attrs) do
    input
    |> Input.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a input.

  ## Examples

      iex> delete_input(input)
      {:ok, %Input{}}

      iex> delete_input(input)
      {:error, %Ecto.Changeset{}}

  """
  def delete_input(%Input{} = input) do
    Repo.delete(input)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking input changes.

  ## Examples

      iex> change_input(input)
      %Ecto.Changeset{data: %Input{}}

  """
  def change_input(%Input{} = input, attrs \\ %{}) do
    Input.changeset(input, attrs)
  end

  @doc """
  Returns the list of solutions.

  ## Examples

      iex> list_solutions()
      [%Solution{}, ...]

  """
  def list_solutions do
    Repo.all(Solution)
  end

  @doc """
  Gets a single solution.

  Raises `Ecto.NoResultsError` if the Solution does not exist.

  ## Examples

      iex> get_solution!(123)
      %Solution{}

      iex> get_solution!(456)
      ** (Ecto.NoResultsError)

  """
  def get_solution!(id), do: Repo.get!(Solution, id)

  @doc """
  Creates a solution.

  ## Examples

      iex> create_solution(%{field: value})
      {:ok, %Solution{}}

      iex> create_solution(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_solution(attrs \\ %{}) do
    %Solution{}
    |> Solution.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a solution.

  ## Examples

      iex> update_solution(solution, %{field: new_value})
      {:ok, %Solution{}}

      iex> update_solution(solution, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_solution(%Solution{} = solution, attrs) do
    solution
    |> Solution.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a solution.

  ## Examples

      iex> delete_solution(solution)
      {:ok, %Solution{}}

      iex> delete_solution(solution)
      {:error, %Ecto.Changeset{}}

  """
  def delete_solution(%Solution{} = solution) do
    Repo.delete(solution)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking solution changes.

  ## Examples

      iex> change_solution(solution)
      %Ecto.Changeset{data: %Solution{}}

  """
  def change_solution(%Solution{} = solution, attrs \\ %{}) do
    Solution.changeset(solution, attrs)
  end
end
