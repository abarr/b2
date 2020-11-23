defmodule B2.Accounts.Tenant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tenants" do
    field :tenant_name, :string
    field :prefix, B2.Accounts.PrefixType
    has_many :users, B2.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(tenant, attrs) do
    attrs = Map.put(attrs, "prefix", attrs["tenant_name"])

    tenant
    |> cast(attrs, [:tenant_name, :prefix])
    |> validate_required([:tenant_name, :prefix])
    |> unsafe_validate_unique(:tenant_name, B2.Repo, message: "This business already has an account")
    |> unique_constraint(:tenant_name, message: "This business already has an account")
  end
end
