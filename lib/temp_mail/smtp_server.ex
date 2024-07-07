defmodule TempMail.SMTPServer do
  @behaviour :gen_smtp_server_session

  def init(hostname, session_count, address, options) do
    banner = ["#{hostname} ESMTP TempMail"]
    state = %{options: options, hostname: hostname}
    {:ok, banner, state}
  end

  def handle_HELO(hostname, state) do
    {:ok, state}
  end

  def handle_EHLO(hostname, extensions, state) do
    {:ok, extensions, state}
  end

  def handle_MAIL(from, state) do
    {:ok, state}
  end

  def handle_MAIL_extension(extension, state) do
    {:ok, state}
  end

  def handle_RCPT(to, state) do
    {:ok, state}
  end

  def handle_RCPT_extension(extension, state) do
    {:ok, state}
  end

  def handle_DATA(from, to, data, state) do
    # Parse the email
    {:ok, email} = :mimemail.decode(data)

    # Extract attachments
    attachments = extract_attachments(email)

    # Prepare email content
    email_content = %{
      from: from,
      to: to,
      subject: get_subject(email),
      body: get_text_body(email),
      attachments: attachments
    }

    TempMail.EmailChannel.broadcast_email(email_content)
    {:ok, "250 ok", state}
  end

  defp extract_attachments({_type, _subtype, headers, _params, parts}) do
    Enum.flat_map(parts, fn part ->
      case part do
        {_type, _subtype, headers, params, content} ->
          case :proplists.get_value("Content-Disposition", headers) do
            :undefined -> []
            disposition ->
              if String.starts_with?(disposition, "attachment") do
                [%{
                  filename: :proplists.get_value("filename", params),
                  content: Base.encode64(content),
                  content_type: :proplists.get_value("Content-Type", headers)
                }]
              else
                []
              end
          end
        _ -> []
      end
    end)
  end

  defp get_subject({_type, _subtype, headers, _params, _parts}) do
    :proplists.get_value("Subject", headers, "")
  end

  defp get_text_body({_type, _subtype, _headers, _params, parts}) do
    Enum.find_value(parts, fn part ->
      case part do
        {"text", "plain", _headers, _params, content} -> content
        _ -> nil
      end
    end) || ""
  end

  def handle_RSET(state) do
    {:ok, state}
  end

  def handle_VRFY(address, state) do
    {:ok, state}
  end

  def handle_other(command, args, state) do
    {:ok, ["500 Error: command not recognized : '#{command}'"], state}
  end

  def handle_AUTH(type, username, password, state) do
    case type do
      :login ->
        {:ok, state}
      :plain ->
        {:ok, state}
      :cram_md5 ->
        {:ok, state}
    end
  end

  def handle_STARTTLS(state) do
    :ok
  end

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end

  def terminate(reason, state) do
    :ok
  end
end
