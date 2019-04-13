defmodule ImgurStorageWeb.Router do
  use ImgurStorageWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", ImgurStorageWeb.V1 do
    pipe_through(:api)

    scope "/v1" do
      post("/upload", ContentController, :upload_content)
      get("/test", ContentController, :test)
    end
  end
end
