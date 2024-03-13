defmodule Philosopher do
  @timeout 1000
  @eat 500
  @sleep 500
  @wait 500

  def start(hunger, left, right, name, ctrl) do
    spawn_link(fn -> hungry(hunger, left, right, name, ctrl) end)
  end

  def hungry(hunger, left, right, name, ctrl) do
    IO.puts("#{name} is hungry")
    case Chopstick.request(left)do
      :granted ->
        IO.puts("#{name} recieved a left chopstick")
      case Chopstick.request(right) do
        :granted ->
          IO.puts("#{name} recieved a right chopstick")
          eating(hunger - 1, left, right, name, ctrl)
        :no ->
          IO.puts("#{name} DIDNT recieved a right chopstick")
          case Chopstick.return(left) do
          :returned -> :timer.sleep(@wait)
            hungry(hunger, left, right, name, ctrl) end
      end
      :no -> :timer.sleep(@wait)
        IO.puts("#{name} DIDNT recieved a left chopstick")
        hungry(hunger, left, right, name, ctrl)
    end
  end

  def eating(hunger, left, right, name, ctrl) do
    #how long should they sleep for?
    :timer.sleep(@eat)
    IO.puts("#{name} has eaten")
    case Chopstick.return(left) do
      :returned ->
        case Chopstick.return(right) do
          :returned ->
            IO.puts("#{name} is sleeping")
            sleep(@sleep)
            IO.puts("#{name} has woken up")
            if(hunger == 0) do done(hunger, left, right, name, ctrl)
            else
              hungry(hunger, left, right, name, ctrl)
            end
        end
    end
  end

  def done(hunger, left, right, name, ctrl) do
    IO.puts("#{name} is done eating")
    send(ctrl,:done)
  end

  def sleep(0) do :ok end
  def sleep(t) do :timer.sleep(:rand.uniform(t)) end

  #-------------------------------------------------------------------------------------------------------------------------------
  #SECOND IMPLEMENTATION

  def start(hunger, strength, left, right, name, ctrl) do
    spawn_link(fn -> hungry(hunger, strength, left, right, name, ctrl) end)
  end

  def hungry(hunger, strength, left, right, name, ctrl) do
    if(strength == 0) do
      IO.puts("#{name} died of hunger")
      send(ctrl, :abort)
    else
    IO.puts("#{name} is hungry")
    case Chopstick.request(left, @timeout) do
      :granted ->
        IO.puts("#{name} recieved a left chopstick")
      case Chopstick.request(right, @timeout) do
        :granted ->
          IO.puts("#{name} recieved a right chopstick")
          eating(hunger - 1, strength, left, right, name, ctrl)
        :no ->
          IO.puts("#{name} DIDNT recieved a right chopstick")
          case Chopstick.return(left) do
            :returned -> :timer.sleep(@wait)
          hungry(hunger, strength - 1, left, right, name, ctrl) end
      end
      :no -> :timer.sleep(@wait)
        IO.puts("#{name} DIDNT recieved a left chopstick")
        hungry(hunger, strength - 1, left, right, name, ctrl)
      end end
  end

  def eating(hunger, strength, left, right, name, ctrl) do
    #how long should they sleep for?
    :timer.sleep(@eat)
    IO.puts("#{name} has eaten")
    case Chopstick.return(left) do
      :returned ->
        case Chopstick.return(right) do
          :returned ->
            IO.puts("#{name} is sleeping")
            sleep(@sleep)
            IO.puts("#{name} has woken up")
            if(hunger == 0) do done(hunger, strength, left, right, name, ctrl)
            else
              hungry(hunger, strength, left, right, name, ctrl)
            end
        end
    end
  end

  def done(hunger, strength, left, right, name, ctrl) do
    IO.puts("#{name} is done eating")
    send(ctrl,:done)
  end

  #-------------------------------------------------------------------------------------------------------------------------------
  #THIRD ASYNCHRONOUS IMPLEMENTATION
  def asynchStart(hunger, strength, left, right, name, ctrl) do
    spawn_link(fn -> asynchHungry(hunger, strength, left, right, name, ctrl) end)
  end

  def asynchHungry(hunger, strength, left, right, name, ctrl) do
    if(strength == 0) do
      #IO.puts("#{name} died of hunger")
      send(ctrl, :abort)
    else
    #IO.puts("#{name} is hungry")
    case Chopstick.asynchRequest(left, right, @timeout) do
      :granted ->
     #   IO.puts("#{name} recieved their chopsticks")
        asynchEating(hunger - 1, strength, left, right, name, ctrl)
      :no -> :timer.sleep(@wait)
 #       IO.puts("#{name} DIDNT recieved a left chopstick")
        asynchHungry(hunger, strength - 1, left, right, name, ctrl)
      end end
  end

  def asynchEating(hunger, strength, left, right, name, ctrl) do
    #how long should they sleep for?
    :timer.sleep(@eat)
 #   IO.puts("#{name} has eaten")
    case Chopstick.return(left) do
      :returned ->
        case Chopstick.return(right) do
          :returned ->
  #          IO.puts("#{name} is sleeping")
            sleep(@sleep)
   #         IO.puts("#{name} has woken up")
            if(hunger == 0) do asynchDone(hunger, strength, left, right, name, ctrl)
            else
              asynchHungry(hunger, strength, left, right, name, ctrl)
            end
        end
    end
  end

  def asynchDone(hunger, strength, left, right, name, ctrl) do
#    IO.puts("#{name} is done eating")
    send(ctrl,:done)
  end
end
