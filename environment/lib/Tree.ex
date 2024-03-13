defmodule EnvTree do
#sample = {:node, key, value, left, right}

#NEW
def new() do
  nil
end

#ADD
def add(nil, key, value) do
    {:node, key, value, nil, nil}
  end

  def add({:node, key, _, left, right}, key, value) do
    {:node, key, value, left, right}
  end

  def add({:node, k, v, left, right}, key, value) when key < k do
    updatedLeft = add(left, key, value)
    {:node, k, v, updatedLeft, right}
  end

  def add({:node, k, v, left, right}, key, value) do
    updatedRight = add(right, key, value)
    {:node, k, v, left, updatedRight}
  end

#LOOKUP
  def lookup(nil, key) do
    :that_node_doesnt_exist
  end

  def lookup({:node, key, v, left, right}, key) do
    {key, v}
  end

  def lookup({:node, k, _, left, right}, key) when key < k do
    lookup(left, key)
  end

  def lookup({:node, k, _, left, right}, key) do
    lookup(right, key)
  end

#REMOVE
  def remove(nil, _) do
    :node_doesnt_exist
  end

  def remove({:node, key, _, nil, right}, key) do
    right
  end

  def remove({:node, key, _, left, nil}, key) do
    left
  end

  def remove({:node, key, _, left, right}, key) do
    {:node, newKey, newValue, _, _} = leftmost(right)
    newleft = deleteleftmost(left)
    {:node, newKey, newValue, newleft, right}
  end

  def remove({:node, k, v, left, right}, key) when key < k do
    updatedLeft = remove(left, key)
    {:node, k, v, updatedLeft, right}
  end

  def remove({:node, k, v, left, right}, key) do
  updatedRight = remove(right, key)
    {:node, k, v, left, updatedRight}end

  def leftmost({:node, key, value, nil, rest}) do
    {:node, key, value, nil, rest}
  end

  def leftmost({:node, _, _, left, _}) do
    leftmost(left)
  end

  def deleteleftmost({:node, _, _, nil, _}) do
    nil
  end

  def deleteleftmost({:node, k, v, left, right}) do
    newleft = deleteleftmost(left)
    {:node, k, v, newleft, right}
  end
end
