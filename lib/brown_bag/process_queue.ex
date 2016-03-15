defmodule ProcessQueue do
  @moduledoc """
  Example usage:

      pid = spawn(ProcessQueue, :run, [])
      send(pid, {self, :size})
      flush # => 0
      send(pid, {:enqueue, 1})
      send(pid, {self, :size})
      flush # => 1
      send(pid, {self, :next})
      flush # => {:ok, 1}
      send(pid, {self, :size})
      flush # => 0
  """

  def run do
    %{queue: :queue.new}
    |> loop
  end

  def loop(state) do
    receive do
      {:enqueue, item} ->
        %{queue: queue} = state
        queue = :queue.in(item, queue)
        loop(%{state | queue: queue})
      {from, :size} ->
        %{queue: queue} = state
        send(from, :queue.len(queue))
        loop(state)
      {from, :next} ->
        %{queue: queue} = state
        case :queue.out(queue) do
          {{:value, item}, queue} ->
            send(from, {:ok, item})
            loop(%{state | queue: queue})
          {:empty, {[], []}} ->
            send(from, :empty)
            loop(state)
        end
      msg ->
        IO.puts "unknown message received #{inspect msg}"
    end
  end

end
