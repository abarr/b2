defmodule B2.TenantTest do
  use B2.DataCase

  # alias B2.Tenant

  # describe "tenants" do
  #   alias B2.Tenant.Accounts

  #   @valid_attrs %{tenant_name: "some name", prefix: "some prefix"}
  #   @update_attrs %{tenant_name: "some updated name", prefix: "some updated prefix"}
  #   @invalid_attrs %{tenant_name: nil, prefix: nil}

  #   def accounts_fixture(attrs \\ %{}) do
  #     {:ok, accounts} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Tenant.create_accounts()

  #     accounts
  #   end

  #   test "list_tenants/0 returns all tenants" do
  #     accounts = accounts_fixture()
  #     assert Tenant.list_tenants() == [accounts]
  #   end

  #   test "get_accounts!/1 returns the accounts with given id" do
  #     accounts = accounts_fixture()
  #     assert Tenant.get_accounts!(accounts.id) == accounts
  #   end

  #   test "create_accounts/1 with valid data creates a accounts" do
  #     assert {:ok, %Accounts{} = accounts} = Tenant.create_accounts(@valid_attrs)
  #     assert accounts.name == "some name"
  #     assert accounts.prefix == "some prefix"
  #   end

  #   test "create_accounts/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Tenant.create_accounts(@invalid_attrs)
  #   end

  #   test "update_accounts/2 with valid data updates the accounts" do
  #     accounts = accounts_fixture()
  #     assert {:ok, %Accounts{} = accounts} = Tenant.update_accounts(accounts, @update_attrs)
  #     assert accounts.name == "some updated name"
  #     assert accounts.prefix == "some updated prefix"
  #   end

  #   test "update_accounts/2 with invalid data returns error changeset" do
  #     accounts = accounts_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Tenant.update_accounts(accounts, @invalid_attrs)
  #     assert accounts == Tenant.get_accounts!(accounts.id)
  #   end

  #   test "delete_accounts/1 deletes the accounts" do
  #     accounts = accounts_fixture()
  #     assert {:ok, %Accounts{}} = Tenant.delete_accounts(accounts)
  #     assert_raise Ecto.NoResultsError, fn -> Tenant.get_accounts!(accounts.id) end
  #   end

  #   test "change_accounts/1 returns a accounts changeset" do
  #     accounts = accounts_fixture()
  #     assert %Ecto.Changeset{} = Tenant.change_accounts(accounts)
  #   end
  # end
end
