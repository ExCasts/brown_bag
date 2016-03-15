defmodule Processes do
	@moduledoc """
  Example usage:

      pid = spawn(Processes, :say, [])
      send(pid, {self, "hello"})
      flush

      send(pid, {self, "hello"})
      receive do
        msg -> IO.puts("handled msg: " <> msg)
      end
  """

  def say do
    receive do
      {from, msg} ->
        IO.puts "Process #{inspect self} says: #{msg}"
        send(from, "hello yourself")
        say
    end
  end
end
