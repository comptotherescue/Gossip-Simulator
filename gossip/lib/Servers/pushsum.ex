  defmodule Gossip.PushSum do
  use GenServer
  require Logger
  def start_link(node, neighbours) do
    GenServer.start_link(__MODULE__, [node, neighbours], name: String.to_atom(Integer.to_string(node)))
  end

  def init([node, neighbours]) do
    receive do
      {:infectmsg, s, w} ->
        task =
          Task.start(fn ->
            start_pushsum(node, neighbours)
          end)

        coverge_progress(3, s + node, w + 1, node, elem(task, 1))
    end

    {:ok, node}
  end

  def start_pushsum(node, neighbours) do
    {s, w} =
      receive do
        {:send, s_rec, w_rec} -> {s_rec, w_rec}
      end

    index = :rand.uniform(length(neighbours)) - 1
    rpeer = Process.whereis(String.to_atom(Integer.to_string(Enum.at(neighbours, index))))

    if rpeer != nil do
      send(rpeer, {:infectmsg, s, w})
    end

    start_pushsum(node, neighbours)
  end

  def coverge_progress(count, s, w, ratio, parent) do
    curr_ratio = s / w
    diff = abs(curr_ratio - ratio)
    count = check_diff(diff, count)

    if count < 1 do
      send(Process.whereis(:supervisor), {:converged, self()})
      Process.exit(self(), :normal)
    else
      s_half = s / 2
      w_half = w / 2
      send(parent, {:send, s_half, w_half})
      listener(count, s_half, w_half, curr_ratio, parent)
    end
  end

  def listener(count, s, w, curr_ratio, parent) do
    receive do
      {:infectmsg, s_receive, w_receive} ->
        coverge_progress(count, s_receive + s, w_receive + w, curr_ratio, parent)
    after
        150 -> coverge_progress(count, s, w, curr_ratio, parent)
    end
  end

  def check_diff(diff, curr_count) do
    cond do
      diff > :math.pow(10, -10) ->
        3

      true ->
        curr_count - 1
    end
  end
end