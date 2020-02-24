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
    |> cast(attrs, [:name, :color])
    |> validate_required([:name, :color])
  end
end
