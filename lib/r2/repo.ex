defmodule B2.Repo do
  use Ecto.Repo,
    otp_app: :b2,
    adapter: Ecto.Adapters.Postgres
end
