defmodule TempMail.MixProject do
  use Mix.Project

  def project do
    [
      app: :temp_mail,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {TempMail.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gen_smtp, "~> 1.2"},
      {:phoenix, "~> 1.6.0"},  # Use 1.6 instead of 1.7
      # {:phoenix_pubsub, "~> 2.0"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.2"},
      {:iconv, "~> 1.0.10"},
      {:timex, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:ecto_sqlite3, "~> 0.7"},
      {:tzdata, "~> 1.1.2", override: true}
    ]
  end
end
