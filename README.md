# SmartConnect

SmartConnect uses principle of minimum spanning shortest path tree based algorithm for relay placement in an IoT network.

algo_hmst.m conatains the algorithm which is being used in designing a multi-hop wireless network for interconnecting sensors or source nodes to a Base Station, by deploying a minimum number of relay nodes at a subset of given potential locations, while meeting a quality of service (QoS) objective specified as a hop count bound for paths from the sources to the Base Station

ComputeWeights.m returns valid edges in the graph S.
If two nodes are within distance range, the edge is valid else invalid.

DP_HC_MWT.m returns shortest path between all the source nodes to the base station
It uses the valid edges to find the shortest path from the source nodes (source_array) with constraint of hop count.

ComputeRelaysUsed.m returns number of relays used by each source node to reach base station.

Prune.m prune the extra relays being used in the design and returns final relays being used in design and path from each source to bae station using the selected relays.
The algorithm uses minimum number of relays to form the design.



