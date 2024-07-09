defmodule TempMail.PageController do
  use Phoenix.Controller
  require Logger

  def index(conn, _params) do
    Logger.debug("Handling request in PageController.index")
    text(conn, "Welcome to TempMail")
  end
end
