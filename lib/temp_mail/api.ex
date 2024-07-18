defmodule TempMail.API do
  use Plug.Router
  require EEx
  alias TempMail.EmailStore

  EEx.function_from_file(:defp, :render_emails, "lib/temp_mail/templates/emails.html.eex", [:assigns])

  plug :match
  plug :dispatch

  get "/emails/:address" do
    emails = EmailStore.get_emails(address)
    assigns = %{address: address, emails: emails}
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, render_emails(assigns))
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
