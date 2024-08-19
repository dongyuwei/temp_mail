defmodule TempMail.API do
  use Plug.Router
  require EEx
  alias TempMail.EmailStore

  EEx.function_from_file(:defp, :render_emails, "lib/temp_mail/templates/emails.html.eex", [:assigns])

  # Compile the template for rendering email generation page
  EEx.function_from_file(:defp, :render_email_page, "lib/temp_mail/templates/email.html.eex", [:assigns])

  plug :match
  plug :dispatch

  get "/emails/:address" do
    emails = EmailStore.get_emails(address)
    assigns = %{address: address, emails: emails}
    if Enum.empty?(emails) do
      send_resp(conn, 404, "Waiting email for #{address}")
    else
      conn
      |> put_resp_content_type("text/html")
      |> send_resp(200, render_emails(assigns))
    end
  end

  get "/" do
    email = generate_temporary_email()
    assigns = %{email: email}
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, render_email_page(assigns))
  end

  defp generate_temporary_email do
    domain = Application.get_env(:temp_mail, TempMail.SMTPServer)[:domain] || "localhost"
    local_part =
      :crypto.strong_rand_bytes(5)
      |> Base.url_encode64()
      |> binary_part(0, 5)

    local_part <> "@" <> domain
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
