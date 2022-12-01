defmodule ElixirRust.Repo.Migrations.CreateSolutions do
  use Ecto.Migration

  def change do
    create table(:solutions) do
      add :language, :string
      add :code, :text
      add :puzzle_id, references(:puzzles, on_delete: :nothing)

      timestamps()
    end

    create index(:solutions, [:puzzle_id])
  end
end
