defmodule Processes do
	@moduledoc """
  Example usage:

      pid = spawn(Processes, :say, [])
      Process.alive?(pid)
      send(pid, {self, "hello"})
      send(pid, {self, "hello"}) # no output this time
      Process.alive?(pid)
  """

  def say do
    receive do
      {from, msg} ->
        IO.puts "Process #{inspect self} says: #{msg}"
    end
  end
end
