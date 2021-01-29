import networkx as nx
import random
import sys
import itertools
import math
import numpy as np
import matplotlib.pyplot as plt
import Graphics as g
import Graph_visualizing as v


def get_neighbour_degree(node):
    edge_list = G.edges(node)
    neighbour_degree_list = []
    for j in range(0, len(edge_list)):
        neighbour_degree_list.insert(len(neighbour_degree_list), G.degree(list(edge_list)[j][1]))
    return sorted(neighbour_degree_list)


def check_identifiability_h1(dictionary):
    count_h1 = [(k, len(list(v))) for k, v in itertools.groupby(sorted(dictionary.values()))]
    # print("count level 1: "+str(count_h1))
    identifiable_h1 = 0
    for j in range(0, len(count_h1)):
        if count_h1[j][1] == 1:
            identifiable_h1 += 1
    print("total re-identifiable H1 nodes: " + str(identifiable_h1))


def check_identifiability_h2(dictionary):
    count_h2 = [(k, len(list(v))) for k, v in itertools.groupby(sorted(dictionary.values()))]
    # print("count level 2: " + str(count_h2))
    identifiable_h2 = 0
    for j in range(0, len(count_h2)):
        if count_h2[j][1] == 1:
            identifiable_h2 += 1
    print("total re-identifiable H2 nodes: " + str(identifiable_h2))


def fill_h1(graph):
    dictionary = {}
    if graph != "":
        for pair in graph.degree:
            dictionary[str(pair[0])] = pair[1]
    else:
        for pair in G.degree:
            dictionary[str(pair[0])] = pair[1]
    return dictionary


def fill_h2(h1_dictionary, graph):
    dictionary = {}
    if graph != "":
        for j in range(min(graph.nodes), len(h1_dictionary)):
            dictionary[str(j)] = get_neighbour_degree(j)
    else:
        for j in range(min(G.nodes), len(h1_dictionary)):
            dictionary[str(j)] = get_neighbour_degree(j)
    return dictionary


def remove_at_random(graph, m):
    for j in range(0, m):
        rand = random.randint(0, len(graph.edges) - 1)
        while not graph.edges.__contains__(list(graph.edges())[rand]):
            rand = random.randint(0, len(graph.edges) - 1)
        graph.remove_edge(list(graph.edges)[rand][0], list(graph.edges)[rand][1])


def add_at_random(graph, m):
    for j in range(0, m):
        rand1 = random.randint(min(graph.nodes), max(graph.nodes))
        rand2 = random.randint(min(graph.nodes), max(graph.nodes))
        while graph.edges.__contains__((rand1, rand2)) or rand1 == rand2:
            rand1 = random.randint(min(graph.nodes), max(graph.nodes))
            rand2 = random.randint(min(graph.nodes), max(graph.nodes))
        graph.add_edge(rand1, rand2)


def random_perturbation(m):
    graph = G.copy(as_view=False)
    edge_length = int(len(graph.edges))
    print("\nwith " + str(m * 100) + "% perturbation --> m: " + str(m))
    m = int(m * edge_length)
    print("random di " + str(m) + " archi")
    remove_at_random(graph, m)
    add_at_random(graph, m)
    # print("final edges: " + str(graph.edges))

    h1_perturbed_dictionary = fill_h1(graph)
    # print(h1_perturbed_dictionary)
    check_identifiability_h1(h1_perturbed_dictionary)
    h2_perturbed_dictionary = fill_h2(h1_perturbed_dictionary, graph)
    # print(h2_perturbed_dictionary)
    check_identifiability_h2(h2_perturbed_dictionary)
    get_graph_info(graph, m)


def get_graph_info(graph, m):
    edge_length = len(graph.edges)
    val1 = math.factorial(edge_length) / (math.factorial(edge_length - m) * math.factorial(m))
    val2 = math.factorial(edge_length + m) / (math.factorial(edge_length) * math.factorial(m))
    poss_world_prob = 1 / (val1 * val2)
    print("possible world prob: " + str(poss_world_prob))
    print("number of edges " + str(len(graph.edges)))
    betweenness_centrality = nx.algorithms.centrality.betweenness_centrality(graph)
    average_betweenness_centrality = sum(betweenness_centrality.values()) / len(betweenness_centrality)
    print("average beetweennes centrality: " + str(average_betweenness_centrality))
    closeness_centrality = nx.algorithms.centrality.closeness_centrality(graph)
    average_closeness_centrality = sum(closeness_centrality.values()) / len(closeness_centrality)
    print("average closeness centrality: " + str(average_closeness_centrality))
    clustering_coefficient = nx.algorithms.cluster.clustering(graph)
    average_clustering_coefficient = sum(clustering_coefficient.values()) / len(clustering_coefficient)
    print("average clustering coefficient: " + str(average_clustering_coefficient))
    average_degree = sum(np.array(graph.degree)[:, 1]) / len(np.array(graph.degree)[:, 1])
    print("average degree: " + str(average_degree))
    if nx.is_connected(graph):
        average_shortest_path = nx.algorithms.shortest_paths.generic.average_shortest_path_length(graph)
        print("average shortest path: " + str(average_shortest_path))
        diameter = nx.diameter(graph)
        print("diameter: " + str(diameter))
    else:
        print("the graph is not connected")
        average_shortest_path = 0
        diameter = 0
    g.fill_first_values(average_betweenness_centrality, average_closeness_centrality, average_clustering_coefficient)
    g.fill_last_values(average_degree, average_shortest_path, diameter)
    perturbation = m/len(graph.edges)*100
    plt.figure(perturbation)
    plt.title("grafo perturbato di " + str(perturbation) + "%")
    nx.draw_circular(graph, with_labels=True)
    v.create_visualizing(graph, perturbation)


def create_graph_from_file():
    if len(sys.argv) < 2:
        print("Error in input")
        sys.exit(-1)

    fd = open(sys.argv[1], "r")
    for value in fd.read().splitlines():
        values = value.split(" ")
        if not G.has_node(int(values[0])):
            G.add_node(int(values[0]))
        if not G.has_node(int(values[1])):
            G.add_node(int(values[1]))
        G.add_edge(int(values[0]), int(values[1]))
    # print("edges: " + str(G.edges))


def vertex_refinement():
    h1_dictionary = fill_h1("")
    # print("dictionary level 1: " + str(h1_dictionary))
    check_identifiability_h1(h1_dictionary)
    h2_dictionary = fill_h2(h1_dictionary, "")
    # print("dictionary level 2: " + str(h2_dictionary))
    check_identifiability_h2(h2_dictionary)
    # print("edges: " + str(G.edges()))
    get_graph_info(G, 0)


def main():
    #create_graph_from_file()
    vertex_refinement()
    for i in (0.05, 0.1, 0.5, 1):
        random_perturbation(i)
    plt.show()
    g.plot_all()



G = nx.random_geometric_graph(100, 0.125)
#G = nx.Graph()
main()
