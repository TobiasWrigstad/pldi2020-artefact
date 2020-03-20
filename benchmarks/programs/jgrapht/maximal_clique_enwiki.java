import it.unimi.dsi.webgraph.*;
import java.io.*;

import org.jgrapht.*;
import org.jgrapht.alg.scoring.*;
import org.jgrapht.alg.color.*;
import org.jgrapht.alg.interfaces.*;
import org.jgrapht.graph.*;
import org.jgrapht.alg.matching.*;
import org.jgrapht.alg.clique.BronKerboschCliqueFinder;
import org.jgrapht.util.*;

import org.jgrapht.alg.interfaces.VertexColoringAlgorithm;

class maximal_clique_enwiki {
    public static int sum = 0;
    public static double sum_double = 0;

    static SimpleGraph construct_graph(String basename, int uplimit) {
        BVGraph graph = null;
        try {
            graph = BVGraph.load(basename, 0);
        } catch (IOException e) {
            System.err.println("Err: " + e);
        }
        System.out.println("Nodes: " + graph.numNodes());
        System.out.println("Edges: " + graph.numArcs());

        var new_graph = new SimpleGraph(DefaultEdge.class);

        var node_iterator = graph.nodeIterator();
        int from;
        var jump = 0;
        while (node_iterator.hasNext()) {
            from = node_iterator.nextInt();

            boolean found = false;
            {
                var successors = node_iterator.successors();
                int to;
                while ((to = successors.nextInt()) != -1) {
                    // System.out.println("to is: " + to);
                    // System.out.println(from + " -> " + to);
                    if (from != to) {
                        found = true;
                        break;
                    }
                }
            }

            if (found) {
                new_graph.addVertex(from);
                var successors = node_iterator.successors();
                int to;
                while ((to = successors.nextInt()) != -1) {
                    // System.out.println("to is: " + to);
                    // System.out.println(from + " -> " + to);
                    if (from != to) {
                        new_graph.addVertex(to);
                        new_graph.addEdge(from, to);
                    }
                }
            }
            if (jump++ > uplimit) {
                break;
            }
        }

        System.out.println("#nodes: " + new_graph.vertexSet().size());
        System.out.println("#edges: " + new_graph.edgeSet().size());

        return new_graph;
    }

    public static void main(String[] args) {

        var graph = construct_graph("./enwiki-2018", 10000);

        BronKerboschCliqueFinder<Integer, DefaultEdge> bkcf =
            new BronKerboschCliqueFinder<>(graph);
        for (var si : bkcf) {
            sum += si.size();
        }
        System.out.println(sum);

        // BrownBacktrackColoring<Integer, DefaultEdge> bbc = new BrownBacktrackColoring<>(graph);
        // sum += bbc.getChromaticNumber();

        // MatchingAlgorithm.Matching<Integer, DefaultEdge> m = new EdmondsMaximumCardinalityMatching<>(graph).getMatching();

        // VertexScoringAlgorithm<Integer, Double> pr = new PageRank<>(graph);
        // pr.getScores().forEach((k, v) -> sum_double += v);
        // System.out.println(sum_double);
    }
}
