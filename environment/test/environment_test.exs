defmodule EnvironmentTest do
  use ExUnit.Case
  doctest Environment

  test "greets the world" do
    assert Environment.hello() == :world
  end
end
