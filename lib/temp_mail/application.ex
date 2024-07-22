defmodule TempMail.Application do
  use Application
  require Logger

  def start(_type, _args) do
    smtp_config = Application.get_env(:temp_mail, TempMail.SMTPServer, [])
    smtp_port = smtp_config[:port]
    smtp_domain = smtp_config[:domain]

    Logger.debug("SMTP configuration: #{inspect(smtp_config)}")
    Logger.info("Starting SMTP server on port #{smtp_port} with domain #{smtp_domain}")

    smtp_options = [
      { :port, smtp_port },
      { :domain, smtp_domain },
      { :protocol, :tcp },
      { :sessionoptions, [ { :callbackoptions, [ { :port, smtp_port, :domain, smtp_domain } ] } ] }
    ]

    Logger.debug("SMTP server options: #{inspect(smtp_options)}")

    children = [
      TempMail.Repo,
      {Plug.Cowboy, scheme: :http, plug: TempMail.API, options: [port: 4000]},
      %{
        id: :gen_smtp_server,
        start: {:gen_smtp_server, :start, [
          TempMail.SMTPServer,
          smtp_options
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
