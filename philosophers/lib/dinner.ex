defmodule Dinner do
  def start(), do: spawn(fn -> init() end)
  def init() do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    Philosopher.start(5, c1, c2, :arendt, ctrl)
    Philosopher.start(5, c2, c3, :hypatia, ctrl)
    Philosopher.start(5, c3, c4, :simone, ctrl)
    Philosopher.start(5, c4, c5, :elisabeth, ctrl)
    Philosopher.start(5, c5, c1, :ayn, ctrl)
    wait(5, [c1, c2, c3, c4, c5], 0)
end

  def start2(), do: spawn(fn -> init2() end)
  def init2() do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    time1 = :os.system_time(:millisecond)
    Philosopher.start(5, 5, c1, c2, :arendt, ctrl)
    Philosopher.start(5, 5, c2, c3, :hypatia, ctrl)
    Philosopher.start(5, 5, c3, c4, :simone, ctrl)
    Philosopher.start(5, 5, c4, c5, :elisabeth, ctrl)
    Philosopher.start(5, 5, c5, c1, :ayn, ctrl)
    wait(5, [c1, c2, c3, c4, c5], time1)
end

  def start3(), do: spawn(fn -> init3() end)
  def init3() do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    hunger = 5
    strength = 5
    waiter = 0
    time1 = :os.system_time(:millisecond)
    Philosopher.asynchStart(hunger, strength, c1, c2, :arendt, ctrl)
    Philosopher.asynchStart(hunger, strength, c2, c3, :hypatia, ctrl)
    Philosopher.asynchStart(hunger, strength, c3, c4, :simone, ctrl)
    Philosopher.asynchStart(hunger, strength, c4, c5, :elisabeth, ctrl)
    Philosopher.asynchStart(hunger, strength, c5, c1, :ayn, ctrl)
    wait(5, [c1, c2, c3, c4, c5], time1)
  end

  def start4(), do: spawn(fn -> init4() end)
  def init4() do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    hunger = 5
    strength = 5
    waiter = 1000
    time1 = :os.system_time(:millisecond)
    Philosopher.asynchStart(hunger, strength, c1, c2, :arendt, ctrl)
    Philosopher.asynchStart(hunger, strength, c3, c4, :simone, ctrl)
    Philosopher.asynchStart(hunger, strength, c2, c3, :hypatia, ctrl)
    Philosopher.asynchStart(hunger, strength, c4, c5, :elisabeth, ctrl)
    :timer.sleep(waiter)
    Philosopher.asynchStart(hunger, strength, c5, c1, :ayn, ctrl)
    wait(5, [c1, c2, c3, c4, c5], time1)
  end

  def wait(0, chopsticks, time1) do
    IO.puts("EVERYONE IS DONE EATING DINNER IS DONE")
    IO.inspect :os.system_time(:millisecond) - time1
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
  end
  def wait(n, chopsticks, time1) do
    receive do
      :done ->
        #IO.puts("SOMEONE is done eating")
        wait(n - 1, chopsticks, time1)
      :abort ->
        IO.puts "someone starved DINNER ABORTED"
        IO.inspect :os.system_time(:millisecond) - time1
        Process.exit(self(), :kill)
  end
  end
end
