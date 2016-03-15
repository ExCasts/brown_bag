defmodule Processes do
	@moduledoc """
  Example usage:

		  pid = spawn(Processes, :say_hello, [])
		  pid = pawn(Processes, :say, ["hello world"])
  """

  def say_hello do
    IO.puts "hello"
  end

  def say(msg) do
    IO.puts msg
  end
end
