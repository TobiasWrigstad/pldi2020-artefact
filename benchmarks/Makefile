.PHONY: bench
bench:
	# compile (seconds)
	cd ~/paper99/benchmarks/programs/synthetic        && make 
	cd ~/paper99/benchmarks/programs/synthetic_cold   && make 
	cd ~/paper99/benchmarks/programs/synthetic_phases && make 
	cd ~/paper99/benchmarks/programs/jgrapht          && make
	# run benchmarks (NOTE: this step will take weeks)
	cd ~/paper99/benchmarks/programs/synthetic        && stack runghc -- hcsgc_run.hs benchmark
	cd ~/paper99/benchmarks/programs/synthetic_cold   && stack runghc -- hcsgc_run.hs benchmark
	cd ~/paper99/benchmarks/programs/synthetic_phases && stack runghc -- hcsgc_run.hs benchmark
	cd ~/paper99/benchmarks/programs/dacapo           && stack runghc -- hcsgc_run.hs benchmark
	cd ~/paper99/benchmarks/programs/jgrapht          && stack runghc -- hcsgc_run.hs benchmark
	# Nullify any non-supported perf's to allow producing the plots
	find ~/paper99/benchmarks/programs/synthetic/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +	
	find ~/paper99/benchmarks/programs/synthetic_cold/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +	
	find ~/paper99/benchmarks/programs/synthetic_phases/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +	
	find ~/paper99/benchmarks/programs/dacapo/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +	
	find ~/paper99/benchmarks/programs/jgrapht/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +	
	# Move logs (seconds)
	# Move synthetic logs to data directory
	mv ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.*.txt ~/paper99/benchmarks/data/synthetic
	mv ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.*.txt ~/paper99/benchmarks/data/synthetic
	# Move synthetic cold logs to data directory
	mv ~/paper99/benchmarks/programs/synthetic_cold/log.total.synthetic_cold.*.txt ~/paper99/benchmarks/data/synthetic_cold
	mv ~/paper99/benchmarks/programs/synthetic_cold/mtime.synthetic_cold.*.txt ~/paper99/benchmarks/data/synthetic_cold
	# Move synthetic phases logs to data directory
	mv ~/paper99/benchmarks/programs/synthetic_phases/log.total.synthetic_phases.*.txt ~/paper99/benchmarks/data/synthetic_phases
	mv ~/paper99/benchmarks/programs/synthetic_phases/mtime.synthetic_phases.*.txt ~/paper99/benchmarks/data/synthetic_phases
	# Move dacapo/h2 logs to data directory
	mv ~/paper99/benchmarks/programs/dacapo/log.total.h2.*.txt ~/paper99/benchmarks/data/dacapo/h2/
	mv ~/paper99/benchmarks/programs/dacapo/mtime.h2.*.txt ~/paper99/benchmarks/data/dacapo/h2/
	# Move dacapo/tradebeans logs to data directory
	mv ~/paper99/benchmarks/programs/dacapo/log.total.tradebeans.*.txt ~/paper99/benchmarks/data/dacapo/tradebeans/
	mv ~/paper99/benchmarks/programs/dacapo/mtime.tradebeans.*.txt ~/paper99/benchmarks/data/dacapo/tradebeans/
	# Move jgrapht logs to data directory
	# MC UK
	mv ~/paper99/benchmarks/programs/jgrapht/log.total.maximal_clique_uk.*.txt ~/paper99/benchmarks/programs/jgrapht/maximal_clique_uk/
	mv ~/paper99/benchmarks/programs/jgrapht/mtime.maximal_clique_uk.*.txt ~/paper99/benchmarks/programs/jgrapht/maximal_clique_uk/
	# MC ENWIKI
	mv ~/paper99/benchmarks/programs/jgrapht/log.total.maximal_clique_enwiki.*.txt ~/paper99/benchmarks/programs/jgrapht/maximal_clique_enwiki/
	mv ~/paper99/benchmarks/programs/jgrapht/mtime.maximal_clique_enwiki.*.txt ~/paper99/benchmarks/programs/jgrapht/maximal_clique_enwiki/
	# CC UK
	mv ~/paper99/benchmarks/programs/jgrapht/log.total.connected_component_uk.*.txt ~/paper99/benchmarks/programs/jgrapht/connected_component_uk/
	mv ~/paper99/benchmarks/programs/jgrapht/mtime.connected_component_uk.*.txt ~/paper99/benchmarks/programs/jgrapht/connected_component_uk/
	# CC ENWIKI
	mv ~/paper99/benchmarks/programs/jgrapht/log.total.connected_component_enwiki.*.txt ~/paper99/benchmarks/programs/jgrapht/connected_component_enwiki/
	mv ~/paper99/benchmarks/programs/jgrapht/mtime.connected_component_enwiki.*.txt ~/paper99/benchmarks/programs/jgrapht/connected_component_enwiki/
	# produce plots (a few minutes -- logs will be displayed if you run in a graphical UI)
	cd ~/paper99/benchmarks/data && stack runghc -- plot.hs
	# open result file
	echo "Now open ~/paper99/benchmarks/results.html in a browser"
	chromium ~/paper99/benchmarks/results.html 1> /dev/null 2> /dev/null &

.PHONY: plots
plots: 
	cd ~/paper99/benchmarks/data && stack runghc -- plot.hs

.PHONY: view
view:
	chromium ~/paper99/benchmarks/results.html 1> /dev/null 2> /dev/null &

.PHONY: zip
zip:
	zip -r results.zip ~/paper99/benchmarks/results.html ~/paper99/benchmarks/data/images/evaluation ~/paper99/benchmarks/data/images/submitted_evaluation

.PHONY: test
test: 
	# compile
	cd ~/paper99/benchmarks/programs/synthetic && make 
	# run benchmarks
	cd ~/paper99/benchmarks/programs/synthetic && stack runghc -- hcsgc_run.hs benchmark_fast
	# Nullify any non-supported perf's to allow producing the plots
	find ~/paper99/benchmarks/programs/synthetic/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +	
	# Move synthetic logs to data directory -- faking iterations!
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.1.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.2.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.3.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.4.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.5.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.6.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.7.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.8.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.9.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.10.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.11.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.12.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.13.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.14.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.15.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.16.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.17.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.18.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.19.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.20.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.21.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.22.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.23.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.24.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.25.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.26.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.27.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.28.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.29.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.30.txt
	cp ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/log.total.synthetic.31.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.1.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.2.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.3.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.4.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.5.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.6.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.7.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.8.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.9.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.10.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.11.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.12.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.13.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.14.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.15.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.16.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.17.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.18.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.19.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.20.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.21.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.22.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.23.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.24.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.25.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.26.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.27.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.28.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.29.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.30.txt
	cp ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.1.txt ~/paper99/benchmarks/data/synthetic/mtime.synthetic.31.txt
	# produce plots
	cd ~/paper99/benchmarks/data && stack runghc -- plot.hs fast
	# open result file
	echo "Now open ~/paper99/benchmarks/results.html in a browser"
	chromium ~/paper99/benchmarks/results.html 1> /dev/null 2> /dev/null &

.PHONY: test_full
test_full: 
	# compile
	cd ~/paper99/benchmarks/programs/synthetic && make 
	cd ~/paper99/benchmarks/programs/synthetic_cold && make 
	cd ~/paper99/benchmarks/programs/synthetic_phases && make 
	# run benchmarks
	cd ~/paper99/benchmarks/programs/synthetic && stack runghc -- hcsgc_run.hs benchmark
	cd ~/paper99/benchmarks/programs/synthetic_cold && stack runghc -- hcsgc_run.hs benchmark
	cd ~/paper99/benchmarks/programs/synthetic_phases && stack runghc -- hcsgc_run.hs benchmark
	# Nullify any non-supported perf's to allow producing the plots
	find ~/paper99/benchmarks/programs/synthetic/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +	
	find ~/paper99/benchmarks/programs/synthetic_cold/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +	
	find ~/paper99/benchmarks/programs/synthetic_phases/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +	
	# Move synthetic logs to data directory
	mv ~/paper99/benchmarks/programs/synthetic/log.total.synthetic.*.txt ~/paper99/benchmarks/data/synthetic
	mv ~/paper99/benchmarks/programs/synthetic/mtime.synthetic.*.txt ~/paper99/benchmarks/data/synthetic
	# Move synthetic cold logs to data directory
	mv ~/paper99/benchmarks/programs/synthetic_cold/log.total.synthetic_cold.*.txt ~/paper99/benchmarks/data/synthetic_cold
	mv ~/paper99/benchmarks/programs/synthetic_cold/mtime.synthetic_cold.*.txt ~/paper99/benchmarks/data/synthetic_cold
	# Move synthetic phases logs to data directory
	mv ~/paper99/benchmarks/programs/synthetic_phases/log.total.synthetic_phases.*.txt ~/paper99/benchmarks/data/synthetic_phases
	mv ~/paper99/benchmarks/programs/synthetic_phases/mtime.synthetic_phases.*.txt ~/paper99/benchmarks/data/synthetic_phases
	# produce plots
	cd ~/paper99/benchmarks/data && stack runghc -- plot.hs slow
	# open result file
	echo "Now open ~/paper99/benchmarks/results.html in a browser"
	chromium ~/paper99/benchmarks/results.html 1> /dev/null 2> /dev/null &

.PHONY: clean_results
clean_results:
	rm -f ~/paper99/benchmarks/data/images/evaluation/*.txt
	rm -f ~/paper99/benchmarks/data/images/submitted_evaluation/*.txt
	rm -f ~/paper99/benchmarks/programs/synthetic/*.txt


