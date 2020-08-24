defmodule ImgurStorage.Tools do
  def hash(value) do
    :crypto.hash(:sha256, value)
    |> Base.encode16()
    |> String.downcase()
  end

  def is_empty?(value) when value in [nil, "null", "", "undefined", %{}, []], do: true
  def is_empty?(_), do: false

  def str_to_bool(value) when is_boolean(value), do: value
  def str_to_bool("true"), do: true
  def str_to_bool("false"), do: false
  def str_to_bool(_), do: false
end
