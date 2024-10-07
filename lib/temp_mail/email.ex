defmodule TempMail.Email do
  use Ecto.Schema
  import Ecto.Changeset

  schema "emails" do
    field :from, :string
    field :to, {:array, :string}
    field :data, :string
    field :subject, :string
    field :content, :string
    field :received_at, :integer

    timestamps()
  end

  def changeset(email, attrs) do
    email
    |> cast(attrs, [:from, :to, :data, :received_at])
    |> validate_required([:from, :to, :data, :received_at])
  end
end
