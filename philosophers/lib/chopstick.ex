defmodule Chopstick do
  #the chopsticks are all proccesses???
  def start do
    stick = spawn_link(fn -> available() end) #new sticks start in the available state
  end

  #the chopstick is available.
  #I think they wait in these functions(states? proccesses?) until the stick recieves recieve a message?????
  #and then the message goes to whatever function the stick(ie proccess) is currently in
  def available() do
    receive do
      {from, :request} -> send(from, :granted) #let the sender know their request has been granted
        gone() #chopstick is now gone
      {from, :asynchRequest} -> send(from, {self(), :granted})
        gone()
      :quit -> :quit
    end
  end

  def gone() do
    receive do
      {from, :request} -> send(from, :no) #tell sender the chopstick is not available
        gone()
      {from,:return} -> send(from, :returned)
        available() #chopstick is available again
    :quit -> :quit
    end
  end

  #ask for a stick
  def request(stick) do
    send(stick, {self(), :request})
    receive do
      :granted -> :granted
      :no -> :no
    end
  end

  def return(stick) do
    send(stick, {self(), :return})
    receive do
      :returned -> :returned
    end
  end

  def terminate(from, stick) do
    send(stick, :quit)
    receive do
      :ok -> send(from, :ok)
    end
  end

  def quit(stick) do
    send(stick, :quit)
  end

  #-------------------------------------------------------------------------------------------------------------------------------
  #SECOND IMPLEMENTATION
  def request(stick, timeout) do
    send(stick, {self(), :request})
    receive do
      :granted -> :granted
      after timeout -> :no
    end
    end

  #-------------------------------------------------------------------------------------------------------------------------------
  #THIRD ASYNCHRONOUS IMPLEMENTATION
    def asynchRequest(leftStick, rightStick, timeout) do
      send(leftStick, {self(), :asynchRequest})
      send(rightStick, {self(), :asynchRequest})
      receive do
        {^leftStick, :granted} -> waiting(leftStick, rightStick, timeout)
        {^rightStick, :granted} -> waiting(rightStick, leftStick, timeout)
      after timeout -> :no
      end
    end

    def waiting(grantedStick, waitingStick, timeout) do
      receive do
        {^waitingStick, :granted} -> :granted
      after timeout ->
        return(grantedStick)
        :no
      end
    end
end
