defmodule TempMail.EmailStore do
  import Ecto.Query
  alias TempMail.{Repo, Email}
  require Logger

  def store_email(from, to, data, subject, content) do
    Logger.info("Storing email from #{from} to #{Enum.join(to, ", ")}")

    email = %Email{
      from: from,
      to: to,
      data: data,
      subject: subject,
      content: content,
      received_at: :os.system_time(:seconds),
    }

    Repo.insert(email)
  end

  def get_emails(address) do
    query = from e in Email, where: ^address in e.to, select: e
    Repo.all(query)
  end
end
