defmodule TempMail.Application do
  use Application

  def start(_type, _args) do
    children = [
      TempMail.Endpoint,
      {Phoenix.PubSub, name: TempMail.PubSub},
      TempMail.EmailStore,
      {Plug.Cowboy, scheme: :http, plug: TempMail.API, options: [port: 4000]},
      %{
        id: :gen_smtp_server,
        start: {:gen_smtp_server, :start, [
          TempMail.SMTPServer,
          [[port: 2525, domain: "localhost", protocol: :tcp]]
        ]},
        type: :worker,
        restart: :permanent,
        shutdown: 5000
      }
    ]

    opts = [strategy: :one_for_one, name: TempMail.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
