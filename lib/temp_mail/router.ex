defmodule TempMail.Router do
  use Phoenix.Router
  require Logger

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :log_request
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TempMail do
    pipe_through :browser

    get "/", PageController, :index
  end

  defp log_request(conn, _opts) do
    Logger.debug("Request path: #{conn.request_path}")
    conn
  end
end
