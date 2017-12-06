defmodule VelixTest do
  use ExUnit.Case
  doctest Velix

  test "greets the world" do
    assert Velix.hello() == :world
  end
end
