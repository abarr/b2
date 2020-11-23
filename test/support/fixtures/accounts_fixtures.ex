defmodule B2.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `B2.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def unique_tenant_name, do: "Test Tenant #{System.unique_integer()}"
  def valid_user_password, do: "hello world!"

  def tenant_fixture(attrs \\ %{}) do
    {:ok, tenant} =
      attrs
      |> Enum.into(%{
        "tenant_name" => unique_tenant_name()
      })
      |> B2.Accounts.register_tenant()

      tenant
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: valid_user_password(),
        salutation: "Mr",
        firstname: "Joe",
        lastname: "Test",
        tenant_id: tenant_fixture().id,
        confirmed_at: NaiveDateTime.local_now()
      })
      |> B2.Accounts.register_user()

    B2.Accounts.get_user!(user.id)
  end

  def unconfirmed_user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: valid_user_password(),
        salutation: "Mr",
        firstname: "Joe",
        lastname: "Test",
        tenant_id: tenant_fixture().id
      })
      |> B2.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    %{text_body: body} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(body, "[TOKEN]")
    token
  end
end
