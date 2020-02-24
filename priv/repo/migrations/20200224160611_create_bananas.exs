defmodule PhoenixAuthSandbox.Repo.Migrations.CreateBananas do
  use Ecto.Migration

  def change do
    create table(:bananas) do
      add :name, :string
      add :color, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:bananas, [:user_id])
  end
end
