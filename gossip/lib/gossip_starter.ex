defmodule Gossip.Starter do
  require Logger
    def start_rumor(topology_selection, n) do
      topology =
        case topology_selection do
            "full" ->
            Gossip.Network.get_full(Enum.to_list(1..n))

            "line" ->
            Gossip.Network.get_line(Enum.to_list(1..n))

            "rand_2d" ->
            Gossip.Network.get_rand_2d(Enum.to_list(1..n))

            "3d_torus" ->
            Gossip.Network.random_3d_torus(Enum.to_list(1..n))

            "honeycomb" ->
            Gossip.Network.get_honeycomb(Enum.to_list(1..n))

            "rand_honeycomb" ->
            Gossip.Network.get_rand_honeycomb(Enum.to_list(1..n))

            true ->
            System.halt()
        end

        num = length(topology)

        for i <- 1..num do
            neighbors = Enum.at(topology, i - 1)

            spawn(fn ->
                Gossip.Rumor.start_link(i, neighbors)
            end)
       end

        coverge_progress = Task.async(fn -> coverge_progress(num) end)
        Process.register(coverge_progress.pid, :supervisor)
        start = System.monotonic_time(unquote(:millisecond))

        gossip_starter(num)
        Task.await(coverge_progress, num * 5000)
        time_spent = System.monotonic_time(unquote(:millisecond)) - start
        Logger.info("Execution time: #{time_spent}")
  end

    def gossip_starter(num) do
        init_node = Process.whereis(String.to_atom(Integer.to_string(Enum.random(1..num))))

        if Process.alive?(init_node) do
        send(init_node, {:infectmsg, "Infected by Aliens at area 51"})
        end
    end

    def coverge_progress(num) do
        cond do
        num > 0 ->
            receive do
            {:converged, pid} ->
             Logger.info("Process #{inspect(pid)} has converged, #{num - 1} more to go")
                coverge_progress(num - 1)
            after
            3000 ->
                coverge_progress(num - 1)
            end

        true ->
            nil
        end
    end
end