defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  # The alias lets us write 'Topic' instead of 'Discuss.Topic'
  alias Discuss.Topic

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    struct = %Topic{}
    params = %{}
    changeset = Topic.changeset(struct, params)
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic} = params) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
          |> put_flash(:info, "Topic created! :)")
          |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id} = params) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic

  end

  def update(conn, %{"id" => topic_id, "topic" => topic} = _params) do
    changeset = Repo.get(Topic, topic_id) |> Topic.changeset(topic)
    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
          |> put_flash(:info, "Topic updated :)")
          |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset
    end
  end

end