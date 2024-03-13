defmodule Dynamic do
  def detect_springs([], mul) do
    :no_springs_are_here
  end

  def detect_springs(list, mul) do
    springs_detector(list, mul)
  end

  def springs_detector(description, mul) do
    [springs,nums] = String.split(description)
    springs =  String.graphemes(springs)

    nums = String.split(nums,",")
    nums = charList_to_intList(nums)

    #IO.inspect {springs, nums}

    memory_check(springs, nums, mul, Map.new(), 1)
  end

  def memory_check(uncheckedSprings, uncheckedNums, 0, memory, combos) do
    combos
  end

  def memory_check(uncheckedSprings, uncheckedNums, mul, memory, combos) do
    key = {uncheckedSprings, uncheckedNums}
    mem = Map.fetch(memory, key)
    if (mem == :error) do
      newValue = detect(uncheckedSprings, uncheckedNums)
      newMemory = Map.put(memory, key, newValue)
      memory_check(uncheckedSprings, uncheckedNums, mul - 1, newMemory, combos * newValue)
    else
      {:ok, value} = mem
      memory_check(uncheckedSprings, uncheckedNums, mul - 1, memory, combos * value)
    end
  end

  def detect([], []) do #good path
  1
end

def detect([], nums) do #bad path
0
end

def detect(springs, []) do #end of nums
  if(Enum.member?(springs, "#")) do
    0
  else
    1
  end
end

def detect([spring1|springs], num) when (spring1 == ".") do
  detect(springs, num)
end

def detect([spring1|springs], [hNum|nums]) do
  case spring1 do
  "#" -> broken(springs, [hNum - 1|nums])
  "?" ->
    broken(springs, [hNum - 1|nums]) + detect(springs, [hNum|nums])
  end
end

def broken([spring1|springs],[hNum|nums]) do
  if (spring1 != "." and hNum > 0) do
    broken(springs, [hNum - 1|nums])
  else if ((spring1 == "#" and hNum == 0) or (spring1 == "." and hNum > 0)) do #bad path
    0
  else
    detect(springs, nums)
  end end
end

def broken([],[0]) do
  1
end

def broken([],a) do
  0
end

  def charList_to_intList([head|tail]) do
    {num, _} = Integer.parse(head)
    [num|charList_to_intList(tail)]
  end
  def charList_to_intList([]) do [] end

end
