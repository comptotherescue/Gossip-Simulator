# Gossip simulator 

**TODO: Gossip type algorithms can be used both for group communication and for aggregate computation. The goal of this project is to determine the convergence of such algorithms through a simulator based on actors written in Elixir. Since actors in Elixir are fully asynchronous, the particular type of Gossip implemented is the so-called Asynchronous Gossip.
Gossip.**

## Installation

#### Build the project

    mix escript.build
#### Running the project

    escript gossip <n> <topology> <algorithm>

    n = number of nodes
    topology = full | line | rand_2d | 3d_torus | honeycomb | rand_honeycomb
    algorithm = gossip|pushsum

    e.g. escript gossip 1000 "3d_torus" "gossip"

## Largest network tested

 10,000 nodes for different topology and algorithms were tested.

## Topologies

Implemented all the topologies listed below for gossip and push sum algorithm -

* Line
* Full
* Random 2D
* 3D Torus
* HoneyComb
* Random HoneyComb

## Group members

Aditya Kulkarni
Apoorv Chandurkar