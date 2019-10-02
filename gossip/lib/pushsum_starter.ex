defmodule Gossip.PushSum.Starter do
  require Logger
    def start_pushsum(topology_selection, n) do
      topology =
        case topology_selection do
            "full" ->
            Gossip.Network.get_full(Enum.to_list(1..n))

            "line" ->
            Gossip.Network.get_line(Enum.to_list(1..n))

            "rand_2d" ->
            Gossip.Network.get_rand_2d(Enum.to_list(1..n))

            "3d_torus" ->
            Gossip.Network.get_3d_torus(n)

            "honeycomb" ->
            Gossip.Network.get_honeycomb(n)

            "rand_honeycomb" ->
            Gossip.Network.get_rand_honeycomb(n)

            true ->
            System.halt()
        end
        
        num = length(topology)
         
        for i <- 1..num do
            neighbors = Enum.at(topology, i - 1)
            spawn(fn ->
                Gossip.PushSum.start_link(i, neighbors)
            end)
       end
        coverge_progress = Task.async(fn -> coverge_progress(num) end)
        Process.register(coverge_progress.pid, :supervisor)
        start = System.monotonic_time(unquote(:millisecond))

        pushsum_starter(num)
        Task.await(coverge_progress, num * 3000)
        time_spent = System.monotonic_time(unquote(:millisecond)) - start
        Logger.info("Execution time: #{time_spent}")
  end

    def pushsum_starter(num) do
        init_node = Process.whereis(String.to_atom(Integer.to_string(Enum.random(1..num))))
        info = Process.info init_node
        name = info[:registered_name]
        Logger.info("#{name}")
        if Process.alive?(init_node) do
        send(init_node, {:infectmsg, 0, 0})
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
                Logger.info("Node unable to converge. Skipping process.")
                coverge_progress(num-1)
            end

        true ->
         Logger.info("Converged!")
            nil
        end
    end
end