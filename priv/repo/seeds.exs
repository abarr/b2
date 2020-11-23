
B2.Accounts.register_user(%{
  salutation: "Mr",
  firstname: "Andrew",
  lastname: "Barr",
  email: "andrew@foxtail.consulting",
  password: Application.get_env(:b2, :admin_account_pw),
  confirmed_at: NaiveDateTime.local_now(),
  admin: true
})

{:ok, tenant} = B2.Accounts.register_tenant(%{ "tenant_name" => "Test Tenant Account"})

B2.Accounts.register_user(%{
  salutation: "Mr",
  firstname: "Joe",
  lastname: "Test",
  email: "andrew.barr@tutamail.com",
  password: Application.get_env(:b2, :test_account_pw),
  confirmed_at: NaiveDateTime.local_now(),
  admin: false,
  tenant_id: tenant.id
})
