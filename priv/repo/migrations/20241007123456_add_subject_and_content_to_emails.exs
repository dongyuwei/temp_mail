defmodule TempMail.Repo.Migrations.AddSubjectAndContentToEmails do
  use Ecto.Migration

  def change do
    alter table(:emails) do
      add :subject, :string
      add :content, :text
    end
  end
end
