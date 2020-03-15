defmodule ImgurStorage.Contents.Contents do
  import Ecto.Query, only: [from: 1, from: 2]
  alias ImgurStorage.Repo
  alias ImgurStorage.Contents.Content

  def create_content(params) do
    %Content{}
    |> Content.changeset(params)
    |> Repo.insert()
  end

  def update_content(struct, attrs) do
    struct |> Content.changeset(attrs) |> Repo.update()
  end

  def get_content_by_id(file_hash) do
    query = from(c in Content, where: c.id == ^file_hash)
    result = Repo.all(query) |> List.first()
    if result, do: {:ok, result}, else: {:error, :entity_not_existed}
  end
end
