defmodule TempMail.PageController do
  use Phoenix.Controller

  def index(conn, _params) do
    text(conn, "Welcome to TempMail")
  end
end
