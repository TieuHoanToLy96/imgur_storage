defmodule ImgurStorage.Contents.Content do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :string, autogenerate: false}
  schema "contents" do
    field(:name, :string)
    field(:path, :string)
    field(:extension, :string)
    field(:size, :integer)
    timestamps()
  end

  def changeset(content, attrs) do
    content
    |> cast(attrs, [:id, :name, :path, :extension, :size])
  end
end
