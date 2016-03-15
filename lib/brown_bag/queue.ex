defmodule Queue do

  use GenServer

  # Public API ############

  def start_link(args \\ [], opts \\ []) do
    GenServer.start_link __MODULE__, args, opts
  end

  def crash(client) do
    GenServer.call client, :crash
  end

  def empty( queue ) do
    GenServer.cast queue, :empty
  end

  def enqueue(queue, item) do
    GenServer.call queue, {:enqueue, item}
  end

  def next( queue ) do
    GenServer.call queue, :next
  end

  def size( queue ) do
    GenServer.call queue, :size
  end

  def stop(client) do
    GenServer.call client, :stop
  end

  # Private API ############

  def init( _args ) do
    Process.flag(:trap_exit, true)

    {:ok, %{queue: :queue.new}}
  end

  def terminate( reason, state ) do
    IO.puts "Stopped for reason: #{reason}"
    :ok
  end

  def handle_call(:crash, _from, state) do
    :ok = {:error, "some error"}
    {:reply, :ok, state}
  end

  def handle_cast(:empty, state) do
    {:noreply, %{state | queue: :queue.new}}
  end

  def handle_call({:enqueue, item}, _from, state) do
    %{queue: queue} = state
    queue = :queue.in(item, queue)

    {:reply, :ok, %{state | queue: queue}}
  end

  def handle_call(:next, _from, %{queue: queue} = state) do
    case :queue.out(queue) do
      {{:value, item}, queue} ->
        {:reply, {:ok, item}, %{state | queue: queue}}
      {:empty, {[], []}} ->
        {:reply, :empty, state}
    end
  end

  def handle_call(:size, _from, %{queue: queue} = state) do
    {:reply, :queue.len(queue), state}
  end

  def handle_call(:stop, _from, status) do
    {:stop, :normal, status}
  end

  def handle_info( {:EXIT, _from, reason}, state) do
    IO.puts "Handling :EXIT, with reason: #{inspect reason}"
    #{:stop, :normal, state}
    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.puts "Received unknown message: #{inspect msg}"
    {:noreply, state}
  end

end
