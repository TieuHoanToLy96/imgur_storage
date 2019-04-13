defmodule ImgurStorage.Tools do
  def hash(value) do
    :crypto.hash(:sha256, value)
    |> Base.encode16()
    |> String.downcase()
  end
end
