defmodule B2.Accounts.Account do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :salutation, :string
    field :firstname, :string
    field :lastname, :string
    field :email, :string
    field :password, :string
    field :tenant_name, :string
  end

  def account_changeset(%__MODULE__{} = rego, params) do
    rego
    |> cast(params, [:salutation, :firstname, :lastname, :email, :password, :tenant_name])
    |> validate_required([:salutation, :firstname, :lastname, :email, :password, :tenant_name],
      message: "Please provide a value"
    )
    |> validate_length(:tenant_name, max: 30)
  end
end
