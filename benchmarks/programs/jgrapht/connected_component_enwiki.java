import it.unimi.dsi.webgraph.*;
import java.io.*;

import org.jgrapht.*;
import org.jgrapht.alg.scoring.*;
import org.jgrapht.alg.color.*;
import org.jgrapht.alg.interfaces.*;
import org.jgrapht.graph.*;
import org.jgrapht.alg.matching.*;
import org.jgrapht.alg.clique.BronKerboschCliqueFinder;
import org.jgrapht.alg.connectivity.*;
import org.jgrapht.util.*;

import org.jgrapht.alg.interfaces.VertexColoringAlgorithm;

class connected_component_enwiki {
    public static int sum = 0;
    public static double sum_double = 0;

    static Graph<Integer, DefaultEdge> construct_graph(String basename, int uplimit) {
        BVGraph graph = null;
        try {
            graph = BVGraph.load(basename, 0);
        } catch (IOException e) {
            System.err.println("Err: " + e);
        }
        System.out.println("Nodes: " + graph.numNodes());
        System.out.println("Edges: " + graph.numArcs());

        // var new_graph = new SimpleGraph(DefaultEdge.class);
        DefaultDirectedGraph<Integer, DefaultEdge> new_graph = new DefaultDirectedGraph<>(DefaultEdge.class);

        var node_iterator = graph.nodeIterator();
        int from;
        var jump = 0;
        boolean should_exit = false;
        while (node_iterator.hasNext()) {
            from = node_iterator.nextInt();

            var successors = node_iterator.successors();
            int to;
            new_graph.addVertex(from);
            while ((to = successors.nextInt()) != -1) {
                // System.out.println("to is: " + to);
                // System.out.println(from + " -> " + to);
                new_graph.addVertex(to);
                new_graph.addEdge(from, to);

                if (jump++ > uplimit) {
                    should_exit = true;
                    break;
                }
            }
            if (should_exit) {
                break;
            }
        }

        System.out.println("#nodes: " + new_graph.vertexSet().size());
        System.out.println("#edges: " + new_graph.edgeSet().size());

        return new_graph;
    }

    public static void main(String[] args) {

        var graph = construct_graph("./enwiki-2018", 80000);

        var inspector = new BiconnectivityInspector<>(graph);
        var size = inspector.getConnectedComponents().size();
        System.out.println(size);
    }
}
