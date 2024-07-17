# File: lib/temp_mail/api.ex
defmodule TempMail.API do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/emails/:address" do
    emails = TempMail.EmailStore.get_emails(address)
    send_resp(conn, 200, Jason.encode!(emails))
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
