defmodule Gossip.Network do
    require Logger
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

  def get_3d_torus(n) do 
      m = round(:math.pow(n, 1 / 3))
      n = trunc(:math.pow(m,3))
      Enum.map(Enum.to_list(1..n), fn x ->
      getNeighbors(x, m)
    end)
  end

  def get_honeycomb(n) do
    Enum.map(Enum.to_list(1..n), fn x ->
      getNeighbors_comb(x, 6, n)
    end)
  end

  def get_rand_honeycomb(n) do
    Enum.map(Enum.to_list(1..n), fn x ->
      get_rand_honeycomblst(x, 6, n)
    end)
  end

  def get_rand_honeycomblst(x, n, nlst) do
    getNeighbors_comb(x, n, nlst) ++ [Enum.random(1..n)]
  end

  def getNeighbors(id, n) do
      tuple = getCoordinates(id, n)
      class = getClass(tuple, n)
      getNeighborslst(tuple, class, n)
  end
   def getCoordinates(id,n) do
        z = div(id,((n*n)+1))
        intermediate = rem(id,n*n)
        if intermediate == 0 do
            x = n-1
            y = n-1
            {x,y,z}
        else
            if rem(intermediate, n) == 0 do
                x = n - 1
                y = div(intermediate, n) - 1
                {x,y,z}
            else
                y = div(intermediate,n)
                x = rem(intermediate,n) - 1
                {x,y,z}
            end
        end
    end

    def getClass(tuple,n) when is_tuple(tuple) do
        {x,y,z} = tuple
        cond do
            x not in [0,n-1] and y not in [0,n-1] and z not in [0,n-1] ->
                4    #return total interior
            (z == 0 or z == n-1) and ({x,y} == {0,0} or {x,y} == {0,n-1} or {x,y} == {n-1,n-1} or {x,y} == {n-1,0}) ->
                1    #return corner 
            (x in [0,n-1] and y in [0,n-1]) or (x in [0,n-1] and z in [0,n-1]) or (y in [0,n-1] and  z in [0,n-1]) ->
                2    #return edge 
            true ->
                3    #return face interior 
        end
    end

    def convertTupleToID({x,y,z},n), do: z*n*n + y*n + x + 1

    def getNeighborslst({x,y,z},class,n) do
        case class do
            4 -> 
                [convertTupleToID({x+1,y,z},n),convertTupleToID({x-1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x,y,z+1},n)]
            1 ->
                cond do
                    z== 0 ->
                        cond do
                            x == 0 ->
                                cond do
                                y == 0 -> 
                                        [convertTupleToID({x+1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x+n-1,y,z},n),convertTupleToID({x,y+n-1,z},n),convertTupleToID({x,y,z+n-1},n)] #For front top-left case 1
                                y == n-1 ->
                                        [convertTupleToID({x+1 ,y,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x+n-1,y,z},n),convertTupleToID({x,y-n+1,z},n),convertTupleToID({x,y,z+n-1},n)] #For front bottom-left case 2
                                end
                            x == n-1 ->
                                cond do
                                   y == 0 ->
                                        [convertTupleToID({x-1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x-n+1,y,z},n),convertTupleToID({x,y+n-1,z},n),convertTupleToID({x,y,z+n-1},n)] #For front top-right case 3
                                    y == n-1 ->
                                        [convertTupleToID({x-1,y,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x-n+1,y,z},n),convertTupleToID({x,y-n+1,z},n),convertTupleToID({x,y,z+n-1},n)] #For front bottom-right case 4
                                end
                        end

                    z == n-1 ->
                        cond do
                            {x,y} == {0,0} -> 
                                [convertTupleToID({x+1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x+n-1,y,z},n),convertTupleToID({x,y+n-1,z},n),convertTupleToID({x,y,z-n+1},n)] #For back top-left case 5
                            {x,y} == {0,n-1} ->
                                [convertTupleToID({x+1,y,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x+n-1,y,z},n),convertTupleToID({x,y-n+1,z},n),convertTupleToID({x,y,z-n+1},n)] #For back bottom-left case 6
                            {x,y} == {n-1,0} ->
                                [convertTupleToID({x-1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x-n+1,y,z},n),convertTupleToID({x,y+n-1,z},n),convertTupleToID({x,y,z-n+1},n)] #For back top-right case 7
                            {x,y} == {n-1,n-1} ->
                                [convertTupleToID({x-1,y,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x-n+1,y,z},n),convertTupleToID({x,y-n+1,z},n),convertTupleToID({x,y,z-n+1},n)] #For back bottom-right case 8
                        end
                end

            2 ->
                cond do
                        {x,z} == {0,0} -> 
                            [convertTupleToID({x+1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x+n-1,y,z},n),convertTupleToID({x,y,z+n-1},n)] #For case 1
                        {x,z} == {0,n-1} ->
                            [convertTupleToID({x+1,y,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x+n-1,y,z},n),convertTupleToID({x,y,z-n+1},n)] #For case 2
                        {x,z} == {n-1,0} ->
                            [convertTupleToID({x-1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x-n+1,y,z},n),convertTupleToID({x,y,z+n-1},n)] #For case 3
                        {x,z} == {n-1,n-1} ->
                            [convertTupleToID({x-1,y,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x-n+1,y,z},n),convertTupleToID({x,y,z-n+1},n)] #For case 4
                        {x,y} == {0,0} -> 
                            [convertTupleToID({x+1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x+n-1,y,z},n),convertTupleToID({x,y+n-1,z},n)] #For case 5
                        {x,y} == {0,n-1} ->
                            [convertTupleToID({x+1,y,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x+n-1,y,z},n),convertTupleToID({x,y-n+1,z},n)] #For case 6
                        {x,y} == {n-1,0} ->
                            [convertTupleToID({x-1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x-n+1,y,z},n),convertTupleToID({x,y+n-1,z},n)] #For case 7
                        {x,y} == {n-1,n-1} ->
                            [convertTupleToID({x-1,y,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x-n+1,y,z},n),convertTupleToID({x,y-n+1,z},n)] #For case 8
                        {y,z} == {0,0} -> 
                            [convertTupleToID({x+1,y,z},n),convertTupleToID({x-1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x,y+n-1,z},n),convertTupleToID({x,y,z+n-1},n)] #For case 9
                        {y,z} == {0,n-1} ->
                            [convertTupleToID({x+1,y,z},n),convertTupleToID({x-1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x,y+n-1,z},n),convertTupleToID({x,y,z-n+1},n)] #For case 10
                        {y,z} == {n-1,0} ->
                            [convertTupleToID({x-1,y,z},n),convertTupleToID({x+1,y,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x,y-n+1,z},n),convertTupleToID({x,y,z+n-1},n)] #For case 11
                        {y,z} == {n-1,n-1} ->
                            [convertTupleToID({x-1,y,z},n),convertTupleToID({x+1,y,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x,y-n+1,z},n),convertTupleToID({x,y,z-n+1},n)] #For case 12
                end

            3 ->
                cond do
                    y == 0 ->
                        [convertTupleToID({x+1,y,z},n),convertTupleToID({x-1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x,y+n-1,z},n)] #For case 1
                    
                    y == n-1 ->
                        [convertTupleToID({x+1,y,z},n),convertTupleToID({x-1,y,z},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y-n+1,z},n)] #For case 2
               
                    z == 0 ->
                        [convertTupleToID({x+1,y,z},n),convertTupleToID({x-1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x,y,z+n-1},n)] #For case 3
                    
                    z == n-1 ->
                        [convertTupleToID({x+1,y,z},n),convertTupleToID({x-1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x,y,z-n+1},n)] #For case 4
                
                    x == 0 ->
                        [convertTupleToID({x+1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x+n-1,y,z},n)] #For case 5
                    
                    x == n-1 ->
                        [convertTupleToID({x-1,y,z},n),convertTupleToID({x,y+1,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x,y,z-1},n),convertTupleToID({x-n+1,y,z},n)] #For case 6

                end
        end
    end

    def getN(num_nodes) when is_integer(num_nodes) do

        trunc(:math.sqrt(num_nodes)) + 1

    end

    def isSameLevel(id1,id_level,n) do
        id1_level  = if rem(id1,n) != 0 do
                        trunc(id1 / n)
                    else
                        trunc(id1 / n) - 1
                    end
        cond do
            id1_level == id_level -> true
            true -> false
        end
    end

    def getNeighbors_comb(id,n,num_nodes) do
        highestLevel = if rem(num_nodes,n) != 0 do
                            trunc(num_nodes / n)
                        else
                            trunc(num_nodes / n) - 1
                        end 

       level =  if rem(id,n) != 0 do
                    trunc(id / n)
                else
                    trunc(id / n) - 1
                end

        cond do
            level == highestLevel ->
                cond do
                    rem(level,2) == 0 ->   
                        cond do
                            rem(id,2) != 0 ->
                                cond do 
                                    id + 1 <= num_nodes ->
                                    cond do
                                        isSameLevel(id+1,level,n) -> [id+1,id-n]
                                    true ->
                                        [id-n]
                                    end
                                end
                            true ->
                                cond do
                                    isSameLevel(id-1,level,n) -> [id-1,id-n]
                                    true -> [id-n]
                                end
                        end
                    true -> 
                        cond do
                            rem(id,2) == 0 ->
                                cond do
                                    id + 1 <= num_nodes ->
                                        cond do
                                            isSameLevel(id+1,level,n) ->
                                                [id+1,id-n]
                                            true ->
                                                [id-n]
                                        end
                                    true ->
                                        [id-n]
                                end
                            true ->
                                cond do
                                    isSameLevel(id-1,level,n) ->
                                        [id-1,id-n]
                                    true ->
                                        [id-n]
                                end
                        end
                end

            level == 0 ->      #highestLevel == 0 case in not handled right now
                cond do 
                    rem(id,2) != 0 ->
                        [id+1,id+n]
                    true ->
                        [id-1,id+n]
                end
            rem(level,2) == 0 ->   #internal even level
                cond do
                    rem(id,2) != 0 ->
                    cond do
                       isSameLevel(id+1,level,n) -> [id+1,id+n,id-n]
                       true -> [id+n,id-n]
                    end
                    true ->
                        cond do
                            isSameLevel(id-1,level,n) -> [id-1,id+n,id-n]
                            true -> [id+n,id-n]
                        end
                end

            true ->  #internal odd level
                cond do
                    rem(id,2) == 0 ->
                        cond do
                            isSameLevel(id+1,level,n) -> [id+1,id-n,id+n]
                            true -> [id-n,id+n]
                        end
                    true ->
                        cond do
                           isSameLevel(id-1,level,n) -> [id-1,id+n,id-n]
                           true -> [id-n,id+n]
                        end

                end
                
        end


    end
end