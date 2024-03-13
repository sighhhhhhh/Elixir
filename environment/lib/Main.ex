defmodule Main do
  def test() do
    map = EnvList.new()
    map = EnvList.add(map, :c, 4)
    map = EnvList.remove(map, :c)
    EnvList.lookup(map,:c)
  end

def listbench(i,n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)
    list = Enum.reduce(seq, EnvList.new(), fn(e, list) ->
      EnvList.add(list, e, :foo)
    end)
    seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)
    {add, _} = :timer.tc(fn() ->
    Enum.each(seq, fn(e) ->
      EnvList.add(list, e, :foo)
  end)
  end)
  {lookup, _} = :timer.tc(fn() ->
  Enum.each(seq, fn(e) ->
    EnvList.lookup(list, e)
  end)
  end)
  {remove, _} = :timer.tc(fn() ->
  Enum.each(seq, fn(e) ->
    EnvList.remove(list, e)
  end)
  end)
  IO.puts "this is for list"
  {i, add, lookup, remove}
end

def treebench(i,n) do
  seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)
  list = Enum.reduce(seq, EnvTree.new(), fn(e, list) ->
    EnvTree.add(list, e, :foo)
  end)
  seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)
  {add, _} = :timer.tc(fn() ->
  Enum.each(seq, fn(e) ->
    EnvTree.add(list, e, :foo)
end)
end)
{lookup, _} = :timer.tc(fn() ->
Enum.each(seq, fn(e) ->
  EnvTree.lookup(list, e)
end)
end)
{remove, _} = :timer.tc(fn() ->
Enum.each(seq, fn(e) ->
  EnvTree.remove(list, e)
end)
end)
IO.puts "this is for tree"
{i, add, lookup, remove}
end

def bench(i,n) do
  IO.inspect (listbench(i,n))
  IO.inspect (treebench(i,n))
  :tada
end


end
