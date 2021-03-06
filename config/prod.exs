use Mix.Config

config :imgur_storage, ImgurStorageWeb.Endpoint,
  http: [compress: true, port: 4002],
  url: [host: "example.com", port: 80],
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

config :imgur_storage, ImgurStorage.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("PG_USERNAME") || "postgres",
  password: System.get_env("PG_PASSWORD") || "postgres",
  database: "imgur_storage_dev",
  hostname: "localhost",
  pool_size: 10
