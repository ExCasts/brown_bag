defmodule Processes do
	@moduledoc """
  Example usage:

      pid = spawn(Processes, :say, [])
      Process.alive?(pid)
      send(pid, {self, "hello"})
      send(pid, {self, "hello"})
      Process.alive?(pid)
  """

  def say do
    receive do
      {from, msg} ->
        IO.puts "Process #{inspect self} says: #{msg}"
        say
    end
  end
end
