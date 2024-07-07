import Config

config :temp_mail, TempMail.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "luQWn1euPY2SlEv++eJcg/awOBwNGPe4IuFr6ZD7uJNugHq38YqQ6TUFQZAaXfEP",
  render_errors: [
    formats: [html: TempMail.ErrorHTML, json: TempMail.ErrorJSON],
    layout: false
  ],
  pubsub_server: TempMail.PubSub,
  live_view: [signing_salt: "your_live_view_signing_salt"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason
