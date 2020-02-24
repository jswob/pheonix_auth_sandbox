defmodule PhoenixAuthSandbox.Fruits do
  @moduledoc """
  The Fruits context.
  """

  import Ecto.Query, warn: false
  alias PhoenixAuthSandbox.Repo

  alias PhoenixAuthSandbox.Fruits.Banana
  alias PhoenixAuthSandbox.Accounts.User

  @doc """
  Returns the list of bananas.

  ## Examples

      iex> list_bananas()
      [%Banana{}, ...]

  """
  def list_bananas do
    Repo.all(Banana)
  end

  @doc """
  Returns the list of bananas for given user.

  ## Examples

      iex> list_user_bananas(user)
      [%Banana{}, ...]

  """
  def list_user_bananas(%User{} = user), do: Repo.all(user_banana_query(user))

  @doc """
  Gets a single banana.

  Raises `Ecto.NoResultsError` if the Banana does not exist.

  ## Examples

      iex> get_banana!(123)
      %Banana{}

      iex> get_banana!(456)
      ** (Ecto.NoResultsError)

  """
  def get_banana!(id), do: Repo.get!(Banana, id)

  @doc """
  Gets a single banana for given user.

  Raises `Ecto.NoResultsError` if the Banana does not exist.

  ## Examples

      iex> get_user_banana!(user, 123)
      %Banana{}

      iex> get_user_banana!(user, 456)
      ** (Ecto.NoResultsError)

  """
  def get_user_banana!(user, id), do: Repo.get!(user_banana_query(user), id)

  @doc """
  Creates a banana.

  ## Examples

      iex> create_banana(%User{}, %{field: value})
      {:ok, %Banana{}}

      iex> create_banana(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_banana(%User{} = user, attrs \\ %{}) do
    %Banana{}
    |> Banana.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a banana.

  ## Examples

      iex> update_banana(banana, %{field: new_value})
      {:ok, %Banana{}}

      iex> update_banana(banana, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_banana(%Banana{} = banana, attrs) do
    banana
    |> Banana.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a banana.

  ## Examples

      iex> delete_banana(banana)
      {:ok, %Banana{}}

      iex> delete_banana(banana)
      {:error, %Ecto.Changeset{}}

  """
  def delete_banana(%Banana{} = banana) do
    Repo.delete(banana)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking banana changes.

  ## Examples

      iex> change_banana(banana)
      %Ecto.Changeset{source: %Banana{}}

  """
  def change_banana(%Banana{} = banana) do
    Banana.changeset(banana, %{})
  end

  defp user_banana_query(user), do: from(b in Ecto.assoc(user, :bananas))
end
