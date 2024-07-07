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
    IO.puts("Received mail from #{from} to #{to}")
    IO.puts("Data: #{data}")

    # Simple parsing of headers and body
    [headers, body] = String.split(data, "\r\n\r\n", parts: 2)
    parsed_headers = parse_headers(headers)

    TempMail.EmailChannel.broadcast_email(%{
      from: from,
      to: to,
      subject: Map.get(parsed_headers, "Subject", ""),
      body: body
    })

    {:ok, "250 ok", state}
  end

  defp parse_headers(headers) do
    headers
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, ": ", parts: 2))
    |> Enum.reduce(%{}, fn [key, value], acc -> Map.put(acc, key, value) end)
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
