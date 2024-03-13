defmodule EvaluateTest do
  use ExUnit.Case
  doctest Evaluate

  test "greets the world" do
    assert Evaluate.hello() == :world
  end
end
