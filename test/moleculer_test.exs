defmodule MoleculerTest do
  use ExUnit.Case
  doctest Moleculer

  test "greets the world" do
    assert Moleculer.hello() == :world
  end
end
