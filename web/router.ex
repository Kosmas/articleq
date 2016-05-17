defmodule Articleq.Router do
  use Articleq.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/", Articleq do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/login", SessionController, :create, as: :login
  end

  # Other scopes may use custom stacks.
  scope "/api", Articleq do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
  end
end
