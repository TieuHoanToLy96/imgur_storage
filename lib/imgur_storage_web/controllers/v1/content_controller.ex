defmodule ImgurStorageWeb.V1.ContentController do
  use ImgurStorageWeb, :controller
  alias ImgurStorage.Contents.Contents
  alias ImgurStorage.Tools
  alias ImgurStorageWeb.ContentView

  action_fallback(ImgurStorageWeb.FallbackController)

  @path_origin File.cwd!()
  def get_file(conn, %{"one" => one, "two" => two, "three" => three, "four" => four} = params) do
    path =
      [one, two, three, four, params["file"]]
      |> Enum.join("/")

    path_file = "#{@path_origin}/upload/#{path}"

    case File.read(path_file) do
      {:ok, binary} ->
        conn
        |> put_resp_header("cache-control", "public, max-age=31557600")
        |> send_resp(200, binary)
    end
  end

  def get_file(conn, params) do
    path =
      [params["year"], params["month"], params["date"], params["file"]]
      |> Enum.join("/")

    path_file = "#{@path_origin}/upload/#{path}"

    case File.read(path_file) do
      {:ok, binary} ->
        conn
        |> put_resp_header("cache-control", "public, max-age=31557600")
        |> send_resp(200, binary)
    end
  end

  def upload_contents_from_urls(list) do
    Enum.with_index(list)
    |> Enum.map(fn {url, index} ->
      upload_content_from_url(url, "avatar-image-#{index}")
    end)
    |> IO.inspect(label: "aaaa", limit: :infinity)
  end

  def upload_content_from_url(url, file_name) do
    date_now = Date.utc_today()
    year = date_now.year
    month = date_now.month
    day = date_now.day
    folder_name = "#{year}/#{month}/#{day}"

    %HTTPoison.Response{body: file_binary} = HTTPoison.get!(url)
    path_folder = "#{@path_origin}/upload/#{folder_name}"
    file_binary_hash = Tools.hash(file_binary)
    path_file = "#{path_folder}/#{file_name}.png"

    path_content =
      if System.get_env("MIX_ENV") == "prod",
        do: "https://storage.tieuhoan.dev#{path_file}",
        else: "http://locallhost:8200#{path_file}"

    path_content = "https://storage.tieuhoan.dev#{path_file}"

    info = %{
      id: file_binary_hash,
      name: file_name,
      extension: "png",
      size: 0,
      path: path_content
    }

    case Contents.get_content_by_id(file_binary_hash) do
      {:error, :entity_not_existed} ->
        case File.mkdir_p(path_folder) do
          :ok ->
            case File.write(path_file, file_binary) do
              :ok ->
                case Contents.create_content(info) do
                  {:ok, content} ->
                    path_content

                  {:error, reason} ->
                    {:error}
                end

              {:error, reason} ->
                {:error}
            end

          {:error, _} ->
            {:error}
        end

      {:ok, content} ->
        case Contents.update_content(content, info) do
          {:ok, content} ->
            path_content

          {:error, reason} ->
            {:falied, :success_false_with_reason, reason}
        end
    end
  end

  def upload_content(conn, _params) do
    req_headers = conn.req_headers
    {:ok, file_binary, _} = read_body(conn)

    %{
      "host" => _host,
      "content-length" => file_size,
      "content-type" => _file_type,
      "x-content-name" => file_name,
      "x-content-extension" => file_extension
    } =
      Enum.reduce(req_headers, %{}, fn {k, v}, acc ->
        Map.put(acc, k, v)
      end)

    file_binary_hash = Tools.hash(file_binary)

    #     folder_name =
    #       String.codepoints(file_binary_hash)
    #       |> Enum.chunk(16)
    #       |> Enum.map(fn el -> Enum.join(el) end)
    #       |> Enum.join("/")

    hash_chunks = for <<x::binary-2 <- file_binary_hash>>, do: x
    [one, two, three, four | rest] = hash_chunks
    folder_name = [one, two, three, four] |> Enum.join("/")

    path_folder = "#{@path_origin}/upload/#{folder_name}"
    path_file = "#{path_folder}/#{file_name}.#{file_extension}"

    path_content =
      if System.get_env("MIX_ENV") == "prod",
        do: "https://storage.tieuhoan.dev#{path_file}",
        else: "http://localhost:8200#{path_file}"

    # path_content = "https://storage.tieuhoan.dev#{path_file}"

    info = %{
      id: file_binary_hash,
      name: file_name,
      extension: file_extension,
      size: file_size,
      path: path_content
    }

    case Contents.get_content_by_id(file_binary_hash) do
      {:error, :entity_not_existed} ->
        case File.mkdir_p(path_folder) do
          :ok ->
            case File.write(path_file, file_binary) do
              :ok ->
                case Contents.create_content(info) do
                  {:ok, content} ->
                    content = ContentView.render("content_just_loaded.json", content)

                    {:success, :with_data, content, "Upload file success"}

                  {:error, reason} ->
                    {:falied, :success_false_with_reason, reason}
                end

              {:error, reason} ->
                {:falied, :success_false_with_reason, reason}
            end

          {:error, _} ->
            {:failed, :success_false_with_reason, "Can not upload this file"}
        end

      {:ok, content} ->
        case Contents.update_content(content, info) do
          {:ok, content} ->
            file = ContentView.render("content_just_loaded.json", content)

            {:success, :with_data, file, "Upload file success"}

          {:error, reason} ->
            {:falied, :success_false_with_reason, reason}
        end
    end
  end
end
