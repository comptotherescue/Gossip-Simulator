defmodule Gossip.Entry do
    def main(args) do
        cond do
        length(args) == 3 ->
            algo = Enum.at(args, 2)
            case algo do
                "gossip"->
                    topology = Enum.at(args, 1)
                    n = Enum.at(args, 0)
                    Gossip.Starter.start_rumor(
                    topology,
                    String.to_integer(n)
                    )
                "pushsum"->
                    topology = Enum.at(args, 1)
                    n = Enum.at(args, 0)
                    Gossip.PushSum.Starter.start_pushsum(
                    topology,
                    String.to_integer(n)
                    )
            end
        true -> IO.puts("Argument error!")
    end 
    end
end