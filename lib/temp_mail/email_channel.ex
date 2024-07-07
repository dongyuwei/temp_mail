defmodule TempMail.EmailChannel do
  use Phoenix.Channel

  def join("email:lobby", _message, socket) do
    {:ok, socket}
  end

  def broadcast_email(email) do
    TempMail.Endpoint.broadcast("email:lobby", "new_email", email)
  end
end
