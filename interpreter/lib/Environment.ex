defmodule Env do
  def hello do
    :world
  end
  def new() do
    []
  end
#sample = [{:a, 12}, {:b, 13}]

  def add(id, str, []) do
    [{id,str}]
  end

  def add(id, str, [h | t]) do
    {i, _} = h
    if(i==id) do
      [{id, str}|t]
    else
      z = add(id, str, t)
      [ h | z ]
    end
  end


  def lookup(id, env) do
    if(length(env) < 1) do
      nil
    else
      lookup2(id, env)
    end
  end

  def lookup2(id, [head | tail]) do
    {i,s} = head
    if(i == id) do
      {i,s}
    else if(length(tail)>0) do
        lookup2(id, tail)
    else
      nil
    end
    end
  end

  def remove([],env) do
    env
  end

  def remove(_,[]) do
    []
  end

  def remove([idhead|idtail], env) do
    newEnv = remove2(idhead, env)
    if (idtail == []) do
      newEnv
    else
      newEnv = remove(idtail, newEnv)
    end
  end

  def remove2(id, [head|tail]) do
    {i,s} = head
    if(i==id) do
        tail
    else
      if (tail == []) do
        [head]
      else
        z = remove2(id,tail)
        [head|z]
      end
    end
  end

  def closure(free, env) do
    closure(free, env, new())
  end
  def closure([], _, closure) do
    {:ok, closure} end

  def closure([v | rest], env, closure) do
    case Env.lookup(v,env) do
    nil -> :error
    {_,s} ->
      closure(rest, env, add(v, s, closure))
    end
  end

  def args([var|variables], [val|values], closure) do
    closure = [{var, val}]++closure
    if (values == []) do
      closure
    else
      closure = args(variables, values, closure)
    end
  end
end
