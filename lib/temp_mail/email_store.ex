# File: lib/temp_mail/email_store.ex
defmodule TempMail.EmailStore do
  use GenServer
  require Logger

  # API

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def store_email(from, to, data) do
    Logger.info("Storing email from #{from} to #{Enum.join(to, ", ")}")
    GenServer.cast(__MODULE__, {:store_email, from, to, data})
  end

  def get_emails(address) do
    GenServer.call(__MODULE__, {:get_emails, address})
  end

  # Callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:store_email, from, to, data}, state) do
    Logger.info("Email data: #{data}")

    email = %{
      from: from,
      to: to,
      data: data,
      received_at: :os.system_time(:seconds)
    }

    new_state = Enum.reduce(to, state, fn address, acc ->
      Logger.info("Storing email for address: #{address}")
      Map.update(acc, address, [email], &[email | &1])
    end)

    Logger.info("New state: #{inspect(new_state)}")

    {:noreply, new_state}
  end

  def handle_call({:get_emails, address}, _from, state) do
    emails = Map.get(state, address, [])
    Logger.info("Retrieving emails for address #{address}: #{inspect(emails)}")
    {:reply, emails, state}
  end
end
