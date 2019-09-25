defmodule Gossip.Rumor do
    use GenServer

    def start_link(node, neighbors) do
        GenServer.start_link(__MODULE__, [node, neighbors], name: String.to_atom(Integer.to_string(node)))
    end

    def start_gossip(neighbors, msg) do
        neighbor = Process.whereis(String.to_atom(Integer.to_string(Enum.random(neighbors))))

        if neighbor != nil do
        send(neighbor, {:infectmsg, msg})
        send(neighbor, {:count, []})
        end

         start_gossip(neighbors, msg)
    end

  def init([node, neighbors]) do
        receive do
        {:infectmsg, msg} ->
            Task.start(fn -> start_gossip(neighbors, msg) end)
            counter(1)
        end
        {:ok, node}
  end

  def counter(count) do
        if(count < 10) do
            receive do
                {:count, _} -> counter(count + 1)
            end
        else
            send(Process.whereis(:supervisor), {:converged, self()})
            Process.exit(self(), :normal)
        end
    end
end
