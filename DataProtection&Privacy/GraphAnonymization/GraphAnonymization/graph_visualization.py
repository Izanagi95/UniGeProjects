import plotly.plotly as py
import plotly.graph_objs as go

import networkx as nx


def get_node_position(G, pos):
    # trovo l'indice ncenter del nodo più vicino al centro(0.5, 0.5)
    dmin = 1
    ncenter = 0
    for n in pos:
        x, y = pos[n]
        d = (x - 0.5) ** 2 + (y - 0.5) ** 2
        if d < dmin:
            ncenter = n
            dmin = d

    p = nx.single_source_shortest_path_length(G, ncenter)
    return p


def create_edges(G):
    edge_trace_in = go.Scatter(
        x=[],
        y=[],
        line=dict(width=0.5, color='#888'),
        hoverinfo='none',
        mode='lines')

    for edge in G.edges():
        x0, y0 = G.node[edge[0]]['pos']
        x1, y1 = G.node[edge[1]]['pos']
        edge_trace_in['x'] += tuple([x0, x1, None])
        edge_trace_in['y'] += tuple([y0, y1, None])

    node_trace_in = go.Scatter(
        x=[],
        y=[],
        text=[],
        mode='markers',
        hoverinfo='text',
        marker=dict(
            showscale=True,
            colorscale='YlGnBu',
            reversescale=True,
            color=[],
            size=10,
            colorbar=dict(
                thickness=15,
                title='Node Connections',
                xanchor='left',
                titleside='right'
            ),
            line=dict(width=2)))

    for node in G.nodes():
        x, y = G.node[node]['pos']
        node_trace_in['x'] += tuple([x])
        node_trace_in['y'] += tuple([y])

    trace = [node_trace_in, edge_trace_in]
    return trace


def color_points(G, node_trace):
    for node, adjacencies in enumerate(G.adjacency()):
        node_trace['marker']['color'] += tuple([len(adjacencies[1])])
        node_info = '# of connections: ' + str(len(adjacencies[1]))
        node_trace['text'] += tuple([node_info])


def draw_network_graph(node_trace, edge_trace, m):
    fig = go.Figure(data=[edge_trace, node_trace],
                    layout=go.Layout(
                        title='<br>Network graph made with Python',
                        titlefont=dict(size=16),
                        showlegend=False,
                        hovermode='closest',
                        margin=dict(b=20, l=5, r=5, t=40),
                        annotations=[dict(
                            text="My code",
                            showarrow=False,
                            xref="paper", yref="paper",
                            x=0.005, y=-0.002)],
                        xaxis=dict(showgrid=False, zeroline=False, showticklabels=False),
                        yaxis=dict(showgrid=False, zeroline=False, showticklabels=False)))
    py.plot(fig, filename=str(m)+'% perturbed')


def create_visualizing(G, m):
    pos = nx.circular_layout(G)
    nx.set_node_attributes(G, pos, name='pos')
    get_node_position(G, pos)
    trace = create_edges(G)
    node_trace = trace[0]
    edge_trace = trace[1]
    color_points(G, node_trace)
    draw_network_graph(node_trace, edge_trace, m)
