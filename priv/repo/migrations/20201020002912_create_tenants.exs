defmodule B2.Repo.Migrations.CreateTenants do
  use Ecto.Migration

  def change do
    create table(:tenants) do
      add :tenant_name, :string
      add :prefix, :string

      timestamps()
    end

    create unique_index(:tenants, [:tenant_name])
  end
end
