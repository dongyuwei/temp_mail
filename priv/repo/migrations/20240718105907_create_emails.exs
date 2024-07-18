defmodule TempMail.Repo.Migrations.CreateEmails do
  use Ecto.Migration

  def change do
    create table(:emails) do
      add :from, :string
      add :to, {:array, :string}
      add :data, :text
      add :received_at, :integer

      timestamps()
    end
  end
end
