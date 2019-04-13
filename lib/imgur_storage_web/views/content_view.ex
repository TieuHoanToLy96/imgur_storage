defmodule ImgurStorageWeb.ContentView do
  def render("content_just_loaded,json", content) when is_map(content) do
    Map.take(content, [:id, :name, :path, :extension, :size])
  end

  def render(_, _), do: nil
end
