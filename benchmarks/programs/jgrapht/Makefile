.PHONY: default
default: compile

.PHONY: compile
compile:
	javac -cp ".:deps/*:./webgraph-3.6.1/webgraph-3.6.1.jar:./jgrapht-core-1.3.1.jar" *.java
	# javac -cp ".:deps/*:./webgraph-3.6.1/webgraph-3.6.1.jar:./jgrapht-core-1.3.1.jar" uk.java
	# javac -cp ".:deps/*:./webgraph-3.6.1/webgraph-3.6.1.jar:./jgrapht-core-1.3.1.jar" enwiki.java

.PHONY: clean
clean:
	rm -rf *.class hs*.log
