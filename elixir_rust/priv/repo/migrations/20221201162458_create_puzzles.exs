defmodule ElixirRust.Repo.Migrations.CreatePuzzles do
  use Ecto.Migration

  def change do
    create table(:puzzles) do
      add :title, :string
      add :description, :text
      add :day, :integer

      timestamps()
    end
  end
end
