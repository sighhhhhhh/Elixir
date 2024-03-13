defmodule Ranges do
  def main do
    string = File.read!("day5.csv")
    list = String.split(string, "\n\n")
    [seeds | functionsString] = list
    listOfFunctions = transform(functionsString,"\n")

    [word| seedsStringList] = String.split(seeds)
    seedsList = charList_to_intList(seedsStringList)
    solve(listOfFunctions, 79)

    values = evaluateSeeds(seedsList, listOfFunctions)

    IO.inspect seeds
    IO.inspect List.flatten([{"seed, value"}, origAndEval(seedsList, values)])
    IO.inspect lowest_value_out_of_these_seeds: Enum.min_by(values, fn x -> x end)
    IO.puts ""

    #---------------------- now we find the seed to get the lowest location value.
    #first we reverse the list
    functionListReverse = Enum.reverse(listOfFunctions)
    [locationFunction|rest] = functionListReverse
    lowestLocation = lowestSource(locationFunction)
    lowestLocationSeed = reverseSolve(functionListReverse, lowestSource(locationFunction))
    IO.inspect "seed for lowest location:"
    [{"seed, location"}, {lowestLocationSeed, lowestLocation}]
  end

  def test do
    function(79, [[50, 98, 2], ~c"420"])
  end

  def map([],_) do
    []
  end
  def map([head|tail], op) do
     [op.(head)| map(tail, op)]
  end

  def reduce([],finalVal,_) do
    finalVal
  end
  def reduce([head|tail], currentVal, op) do
    reduce(tail, op.(head, currentVal), op)
  end

  def transform(list, splitter) do map(list, fn(a) ->
    [functionName|rest] = String.split(a,splitter)
    {functionName,listsInList(rest, "\n")}
  end) end

  def listsInList(list, splitter) do map(list, fn(a) ->
    [string] = String.split(a,splitter)
    a = String.split(string, " ")
    b = charList_to_intList(a)
  end) end
  def evaluateSeeds(seedList, functionsList) do map(seedList, fn(a) -> solve(functionsList, a) end) end

  def solve(functions, seed) do reduce(functions, seed, fn(a,b) -> function(a,b) end) end
  def reverseSolve(functions, seed) do reduce(functions, seed, fn(a,b) -> reverseFunction(a,b) end) end


  def charList_to_intList([head|tail]) do
    num = String.to_integer(head)
    [num|charList_to_intList(tail)]
  end
  def charList_to_intList([]) do [] end

  def function({functionName, []}, seed) do
    seed
  end
  def function({functionName,[[dest, source, range]|rest]}, seed) do
    if (source <= seed and seed <= source + range - 1) do
      seed = seed + (dest - source)
    else
      function({functionName, rest}, seed)
    end
  end

  def reverseFunction({functionName, []}, seed) do
    seed
  end
  def reverseFunction({functionName,[[source, dest, range]|rest]}, seed) do
    if (source <= seed and seed <= source + range - 1) do
      seed = seed + (dest - source)
    else
      reverseFunction({functionName, rest}, seed)
    end
  end

  def origAndEval([], []) do [] end
  def origAndEval([origHead | original], [evalHead | evaluated]) do
    List.flatten([{origHead, evalHead}, origAndEval(original, evaluated)])
  end

  def lowestSource({functionName,[[source, dest, range]|[]]}) do
    source
  end

  def lowestSource({functionName,[[source, dest, range]|rest]}) do
    if (source < lowestSource({functionName, rest})) do
      source
    else
      lowestSource({functionName, rest})
    end
  end
end
