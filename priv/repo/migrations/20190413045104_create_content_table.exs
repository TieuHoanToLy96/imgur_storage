defmodule ImgurStorage.Repo.Migrations.CreateContentTable do
  use Ecto.Migration

  def up do
    create table(:contents, primary_key: false) do
      add(:id, :string, null: false)
      add(:name, :string)
      add(:path, :string)
      add(:size, :integer)
      add(:extension, :string)
      timestamps()
    end
  end

  def down do
    drop_if_exists(table(:contents))
  end
end
