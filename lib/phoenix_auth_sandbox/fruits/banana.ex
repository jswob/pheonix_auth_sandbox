defmodule PhoenixAuthSandbox.Fruits.Banana do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bananas" do
    field :color, :string
    field :name, :string

    belongs_to :user, PhoenixAuthSandbox.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(banana, attrs) do
    banana
    |> cast(attrs, [:name, :color, :user_id])
    |> validate_required([:name, :color, :user_id])
  end
end
