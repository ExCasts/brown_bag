defmodule Queue do

  use GenServer

  # Public API ############

  def start_link(args \\ [], opts \\ []) do
    GenServer.start_link __MODULE__, args, opts
  end

  def enqueue(queue, item) do
    GenServer.call queue, {:enqueue, item}
  end

  # Private API ############

  def init( _args ) do
    {:ok, %{queue: :queue.new}}
  end

  def handle_call({:enqueue, item}, _from, state) do
    %{queue: queue} = state
    queue = :queue.in(item, queue)

    {:reply, :ok, %{state | queue: queue}}
  end

end
