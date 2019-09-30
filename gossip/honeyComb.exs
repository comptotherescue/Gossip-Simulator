defmodule HC_neighbors do
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

    def getNeighbors(id,n,num_nodes) do
        highestLevel = if rem(num_nodes,n) != 0 do
                            trunc(num_nodes / n)
                        else
                            trunc(num_nodes / n) - 1
                        end 
        IO.puts "#{highestLevel}"

       level =  if rem(id,n) != 0 do
                    trunc(id / n)
                else
                    trunc(id / n) - 1
                end
        IO.puts "#{level}"

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