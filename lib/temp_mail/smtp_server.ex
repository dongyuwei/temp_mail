defmodule TempMail.SMTPServer do
  @behaviour :gen_smtp_server_session
  require Logger

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
    Logger.info("handle_DATA, Received email from #{from} to #{Enum.join(to, ", ")}")
    TempMail.EmailStore.store_email(from, to, data)

    case :mimemail.decode(data) do
      {"text", subtype, headers, params, body} ->
        # Simple text email without attachments
        email_content = %{
          from: from,
          to: to,
          subject: get_subject({nil, nil, headers, params, nil}),
          body: body,
          attachments: []
        }
        TempMail.EmailChannel.broadcast_email(email_content)
        {:ok, "250 ok", state}

      {_type, _subtype, headers, params, parts} = email ->
        # Email with potential attachments
        attachments = extract_attachments(email)
        email_content = %{
          from: from,
          to: to,
          subject: get_subject(email),
          body: get_text_body(email),
          attachments: attachments
        }
        TempMail.EmailChannel.broadcast_email(email_content)
        {:ok, "250 ok", state}

      error ->
        {:error, "554 Error: Unable to process email", state}
    end
  end

  defp extract_attachments({_type, _subtype, _headers, _params, parts}) when is_list(parts) do
    Enum.flat_map(parts, fn
      {"text", _subtype, _headers, _params, _content} ->
        []
      {_type, _subtype, headers, params, content} ->
        case :proplists.get_value("Content-Disposition", headers) do
          disposition when is_binary(disposition) ->
            if String.starts_with?(disposition, "attachment") do
              [%{
                filename: :proplists.get_value("filename", params),
                content: Base.encode64(content),
                content_type: :proplists.get_value("Content-Type", headers)
              }]
            else
              []
            end
          _ ->
            []
        end
    end)
  end
  defp extract_attachments(_), do: []

  defp get_subject({_type, _subtype, headers, _params, _parts}) do
    :proplists.get_value("Subject", headers, "")
  end

  defp get_text_body({_type, _subtype, _headers, _params, parts}) when is_list(parts) do
    Enum.find_value(parts, fn
      {"text", "plain", _headers, _params, content} -> content
      _ -> nil
    end) || ""
  end
  defp get_text_body({"text", "plain", _headers, _params, content}), do: content
  defp get_text_body(_), do: ""

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
