import math

class Edge:
    def __init__(self, node, value):
        self.node = node
        self.value = value
        
class Node:
    def __init__(self, value):
        self.edges = []
        self.value = value
    def add_edge(self, node, value):
        self.edges.append(Edge(node, value))

class Graph:
    def __init__(self):
        self.nodes = []
    def add_node(self, node):
        self.nodes.append(node)
    def find_node(self, value):
        for node in self.nodes:
            if node.value == value:
                return node
        
def distance(x, y):
    return math.sqrt((x[0] - y[0])**2 + (x[1] - y[1])**2)
        
def build_graph(M):
    graph = Graph()
    for node, edges in enumerate(M.roads):
        this_node = Node(node)
        for edge in edges:
            this_node.add_edge(edge, distance(M.intersections[node], M.intersections[edge]))
        graph.add_node(this_node)
    return graph

def lowest_F_score(frontier, F):
    node = frontier[0]
    lowF = F[node]
    for temp_node in frontier:
        if F[temp_node] < lowF:
            lowF = F[temp_node]
            node = temp_node
    return node

def build_path(node, Child2Parent):
    path = []
    path.append(node)
    while node in Child2Parent.keys():
        node = Child2Parent[node]
        path.append(node)
    path.reverse()
    return path
    
def shortest_path(M,start,goal):
    graph = build_graph(M)
    
    frontier = []
    explored = []
    
    F = {}
    G = {}
    H = {}
    
    Child2Parent = {}
    
    frontier.append(start)
    G[start] = 0 
    H[start] = distance(M.intersections[start], M.intersections[goal])
    F[start] = G[start] + H[start]
    
    while len(frontier) != 0:
        current_node = lowest_F_score(frontier, F)
        frontier.remove(current_node)
        explored.append(current_node)
        if current_node == goal:
            return build_path(goal, Child2Parent)
        for nbr in graph.find_node(current_node).edges:
            if nbr.node in explored:
                continue
            tentative_G_score = G[current_node] + nbr.value
            if nbr.node not in frontier:
                frontier.append(nbr.node)
            elif tentative_G_score >= G[nbr.node]:
                    continue
            G[nbr.node] = tentative_G_score
            H[nbr.node] = distance(M.intersections[nbr.node], M.intersections[goal])
            F[nbr.node] = G[nbr.node] + H[nbr.node]
            Child2Parent[nbr.node] = current_node