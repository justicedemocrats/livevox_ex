defmodule LivevoxTest do
  use ExUnit.Case
  doctest Livevox

  test "greets the world" do
    assert Livevox.hello() == :world
  end
end
