defmodule Gossip.Network do

    def get_full(nlist) do
    Enum.map(nlist, fn node ->
      neighbours = Enum.to_list(nlist)
      List.delete(neighbours, node)
    end)
  end

  def get_line(nlist) do
    Enum.map(nlist, fn x ->
      cond do
        x == 1 -> [x + 1]
        x == length(nlist) -> [x - 1]
        true -> [x + 1, x - 1]
      end
    end)
  end

  def get_rand_2d(nlist) do
    nlocation = Enum.map(nlist, fn _ -> [:rand.uniform(), :rand.uniform()] end)
  
    distance_map =
      Enum.map(nlocation, fn location ->
        x = Enum.at(location, 0)
        y = Enum.at(location, 1)

        Enum.map(nlocation, fn other_node ->
          a = :math.pow(x - Enum.at(other_node, 0), 2)
          b = :math.pow(y - Enum.at(other_node, 1), 2)
          :math.sqrt(a + b)
        end)
      end)
    
      result =
      Enum.map(distance_map, fn neighbours ->
        Enum.filter(0..(length(neighbours) - 1), fn i ->
          Enum.at(neighbours, i) < 0.1 && Enum.at(neighbours, i) != 0
        end)
      end)
    Enum.map(result, fn peers ->
      if length(peers) == 0 do
        IO.puts("Disconnected network created! exiting...")
        System.halt()
      end
    end)

    result
  end


end