defmodule TodoApp.TodoList do
  use Exon.AggregateRoot, default_aggregate_id: :list_uuid
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__, as: TodoList

  schema "todo_lists" do
    field :uuid
    field :name
    field :archived, :boolean
  end

  @command new: true
  def create_todo_list(%TodoList{} = list, %{list_uuid: list_uuid, name: name}) do
    {
      :ok,
      change(list, %{uuid: list_uuid, name: name}),
      [{:todo_list_created, %{list_uuid: list_uuid, name: name}}]
    }
  end

  @command []
  def archive_todo_list(%TodoList{archived: true}, %{}) do
    :ok
  end

  def archive_todo_list(%TodoList{} = list, %{list_uuid: list_uuid}) do
    {
      :ok,
      change(list, %{archived: true}),
      [{:todo_list_archived, %{list_uuid: list_uuid}}]
    }
  end

  def get(uuid) do
    import Ecto.Query, only: [from: 2]
    from(l in TodoList, where: l.uuid == ^uuid)
  end
end
