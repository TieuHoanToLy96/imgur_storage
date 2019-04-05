defmodule ImgurStorageWeb.Router do
  use ImgurStorageWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ImgurStorageWeb do
    pipe_through :api
  end
end
