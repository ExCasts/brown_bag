defmodule Queue do

  use GenServer

  # Public API ############

  def start_link(args \\ [], opts \\ []) do
    GenServer.start_link __MODULE__, args, opts
  end

  # Private API ############

  def init( _args ) do
    {:ok, %{queue: :queue.new}}
  end

end
