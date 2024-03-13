defmodule Main do
  def test1 do
    test =
"???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1"
    total = Springs.detect_springs(String.split(test,"\n"))
    IO.inspect(total: total)
  end

  def test2 do
    test = "???.### 1,1,3"
    total = Springs.detect_springs(test, 5)
    IO.inspect(total: total)
  end

  def test3 do
    test = "???.### 1,1,3"
    total = Dynamic.detect_springs(test, 5)
    IO.inspect(total: total)
  end

  def test4 do
    map = Map.new()
    map = Map.put(map, "key", "value")
    map = Map.fetch(map, "key")
  end

  def bench1 do
    :timer.tc(fn() -> test1() end)
  end

  def bench2 do
    :timer.tc(fn() -> test2() end)
  end

  def bench3 do
    :timer.tc(fn() -> test3() end)
  end

  def bench4 do
    :timer.tc(fn() -> test4() end)
  end

end
