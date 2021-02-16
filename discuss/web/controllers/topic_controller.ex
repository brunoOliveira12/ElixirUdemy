defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  def new(conn, _params) do
    changeset = Discuss.Topic.changeset(%Discuss.Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Discuss.Topic.changeset(%Discuss.Topic{}, topic)
    case Repo.insert(changeset) do
       {:ok, _topic} ->
          conn
          |> put_flash(:info, "Topic Created")
          |> redirect(to: topic_path(conn, :index))
       {:error, changeset} -> IO.inspect(changeset)
          render conn, "new.html", changeset: changeset
    end
  end

  def index(conn, _params) do
    topics = Repo.all(Discuss.Topic)
    render conn, "index.html", topics: topics
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Discuss.Topic, topic_id)
    changeset = Discuss.Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Discuss.Topic, topic_id)
    changeset = Repo.get(Discuss.Topic, topic_id)
    |> Discuss.Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
          |> put_flash(:info, "Topic Updated")
          |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
          render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Discuss.Topic, topic_id) |> Repo.delete!

    conn
      |> put_flash(:info, "Topic Deleted")
      |> redirect(to: topic_path(conn, :index))
  end
end
