defmodule Get_3DNeighbors do
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

    def getNeighbors({x,y,z},class,n) do
        IO.puts class
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
                                        [convertTupleToID({x+1,y,z},n),convertTupleToID({x,y-1,z},n),convertTupleToID({x,y,z+1},n),convertTupleToID({x+n-1,y,z},n),convertTupleToID({x,y-n+1,z},n),convertTupleToID({x,y,z+n-1},n)] #For front bottom-left case 2
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
                        
                        x == 0 and z ==0 -> 
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

         

    
end