# Why You Should Use Elixir and Phoenix for Your Next Project?

Based on this [article](http://blog.plataformatec.com.br/2015/06/elixir-in-times-of-microservices) by Jose Valim.

* Elixir is expressive and pleasant to learn and work with
* Elixir borrowed lots of good ideas from Ruby (and almost every other language that has ever had a good idea)
* Elixir is appropriate for single node or milti-node distributed systems
* Phoenix borrowed lots of good ideas from Rails thus reaching the critical mass of concepts needed to order to get stuff done is not daunting
* Phoenix fixes many of Rails issues
    * Repository vs ActiveRecord pattern
    * Changesets vs. model validations, callbacks and strong parameters


## Concurrency Model

### Processes and Messaging

> Because all Elixir processes communicate with each other via message passing, the runtime provides a feature called location 
> transparency. This means it doesn’t really matter if two processes are in the same node or in different ones, they are still 
> able to exchange messages. - Jose Valim

Simplest example:

    pid = spawn(fn -> IO.puts "hello" end)
    Process.alive?(pid)

Getting the PID example:

    self
    spawn(fn -> IO.puts(inspect(self)) end)

A simple module example:

    defmodule Processes do
      def say_hello do
        IO.puts "hello"
      end

      def say(msg) do
        IO.puts msg
      end
    end

    spawn(Processes, :say_hello, [])
    spawn(Processes, :say, ["Jason"])

A simple message passing example:

    defmodule Processes do
      def say do
        receive do
          {from, msg} ->
            IO.puts "Process #{inspect self} says: #{msg}"
        end
      end
    end

    pid = spawn(Processes, :say, [])
    send(pid, {self, "hello"})
    send(pid, {self, "hello"}) # no output this time
    Process.alive?(pid)

A simple recursive message passing example:

    defmodule Processes do
      def say do
        receive do
          {from, msg} ->
            IO.puts "Process #{inspect self} says: #{msg}"
            say
        end
      end
    end

    pid = spawn(Processes, :say, [])
    send(pid, {self, "hello"})
    send(pid, {self, "hello"}) # with output this time

#### Process Mailbox

A simple message passing example with a reply message:

    defmodule Processes do
      def say do
        receive do
          {from, msg} ->
            IO.puts "Process #{inspect self} says: #{msg}"
            send(from, "hello yourself")
            say
        end
      end
    end

    pid = spawn(Processes, :say, [])
    send(pid, {self, "hello"}) # no reply message represented
    flush

    # now handle reply with receive
    receive do
      msg -> IO.puts("handled msg: #{msg}"
    end

### GenServer (Generic Server)

The GenServer is an abstraction that will have a standard set of interface functions and includes functionality for tracing 
and error reporting. It will also have the interface necessary to be placed into a supervision tree.

A GenServer is a process like any other Elixir process and it can be used to keep state, execute code asynchronously and 
so on.

