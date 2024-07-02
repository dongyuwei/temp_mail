defmodule TempMailTest do
  use ExUnit.Case
  doctest TempMail

  test "greets the world" do
    assert TempMail.hello() == :world
  end
end
