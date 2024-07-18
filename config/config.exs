import Config

config :phoenix, :json_library, Jason

config :temp_mail, TempMail.Repo,
  database: Path.expand("../priv/repo/db/temp_mail.sqlite3", __DIR__)

config :temp_mail,
  ecto_repos: [TempMail.Repo]

config :temp_mail, TempMail.SMTPServer,
  port: 2525
