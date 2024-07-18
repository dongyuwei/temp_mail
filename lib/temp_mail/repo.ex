defmodule TempMail.Repo do
  use Ecto.Repo,
    otp_app: :temp_mail,
    adapter: Ecto.Adapters.SQLite3
end
