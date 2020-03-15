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

  scope "/", ImgurStorageWeb.V1 do
    get("/root/imgur_storage/upload/:year/:month/:date/:file", ContentController, :get_file)
    get("/app/upload/:year/:month/:date/:file", ContentController, :get_file)
  end
end
