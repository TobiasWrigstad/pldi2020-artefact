project_root := "~/paper99"

.PHONY: bench
bench:
	# compile (seconds)
	cd ${project_root}/benchmarks/programs/synthetic        && make
	cd ${project_root}/benchmarks/programs/synthetic_cold   && make
	cd ${project_root}/benchmarks/programs/synthetic_phases && make
	cd ${project_root}/benchmarks/programs/jgrapht          && make
	# run benchmarks (NOTE: this step will take weeks)
	cd ${project_root}/benchmarks/programs/synthetic        && stack runghc -- hcsgc_run.hs benchmark
	cd ${project_root}/benchmarks/programs/synthetic_cold   && stack runghc -- hcsgc_run.hs benchmark
	cd ${project_root}/benchmarks/programs/synthetic_phases && stack runghc -- hcsgc_run.hs benchmark
	cd ${project_root}/benchmarks/programs/dacapo           && stack runghc -- hcsgc_run.hs benchmark
	cd ${project_root}/benchmarks/programs/jgrapht          && stack runghc -- hcsgc_run.hs benchmark
	# Nullify any non-supported perf's to allow producing the plots
	find ${project_root}/benchmarks/programs/synthetic/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +
	find ${project_root}/benchmarks/programs/synthetic_cold/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +
	find ${project_root}/benchmarks/programs/synthetic_phases/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +
	find ${project_root}/benchmarks/programs/dacapo/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +
	find ${project_root}/benchmarks/programs/jgrapht/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +
	# Move logs (seconds)
	# Move synthetic logs to data directory
	mv ${project_root}/benchmarks/programs/synthetic/log.total.synthetic.*.txt ${project_root}/benchmarks/data/synthetic
	mv ${project_root}/benchmarks/programs/synthetic/mtime.synthetic.*.txt ${project_root}/benchmarks/data/synthetic
	# Move synthetic cold logs to data directory
	mv ${project_root}/benchmarks/programs/synthetic_cold/log.total.synthetic_cold.*.txt ${project_root}/benchmarks/data/synthetic_cold
	mv ${project_root}/benchmarks/programs/synthetic_cold/mtime.synthetic_cold.*.txt ${project_root}/benchmarks/data/synthetic_cold
	# Move synthetic phases logs to data directory
	mv ${project_root}/benchmarks/programs/synthetic_phases/log.total.synthetic_phases.*.txt ${project_root}/benchmarks/data/synthetic_phases
	mv ${project_root}/benchmarks/programs/synthetic_phases/mtime.synthetic_phases.*.txt ${project_root}/benchmarks/data/synthetic_phases
	# Move dacapo/h2 logs to data directory
	mv ${project_root}/benchmarks/programs/dacapo/log.total.h2.*.txt ${project_root}/benchmarks/data/dacapo/h2/
	mv ${project_root}/benchmarks/programs/dacapo/mtime.h2.*.txt ${project_root}/benchmarks/data/dacapo/h2/
	# Move dacapo/tradebeans logs to data directory
	mv ${project_root}/benchmarks/programs/dacapo/log.total.tradebeans.*.txt ${project_root}/benchmarks/data/dacapo/tradebeans/
	mv ${project_root}/benchmarks/programs/dacapo/mtime.tradebeans.*.txt ${project_root}/benchmarks/data/dacapo/tradebeans/
	# Move jgrapht logs to data directory
	# MC UK
	mv ${project_root}/benchmarks/programs/jgrapht/log.total.maximal_clique_uk.*.txt ${project_root}/benchmarks/programs/jgrapht/maximal_clique_uk/
	mv ${project_root}/benchmarks/programs/jgrapht/mtime.maximal_clique_uk.*.txt ${project_root}/benchmarks/programs/jgrapht/maximal_clique_uk/
	# MC ENWIKI
	mv ${project_root}/benchmarks/programs/jgrapht/log.total.maximal_clique_enwiki.*.txt ${project_root}/benchmarks/programs/jgrapht/maximal_clique_enwiki/
	mv ${project_root}/benchmarks/programs/jgrapht/mtime.maximal_clique_enwiki.*.txt ${project_root}/benchmarks/programs/jgrapht/maximal_clique_enwiki/
	# CC UK
	mv ${project_root}/benchmarks/programs/jgrapht/log.total.connected_component_uk.*.txt ${project_root}/benchmarks/programs/jgrapht/connected_component_uk/
	mv ${project_root}/benchmarks/programs/jgrapht/mtime.connected_component_uk.*.txt ${project_root}/benchmarks/programs/jgrapht/connected_component_uk/
	# CC ENWIKI
	mv ${project_root}/benchmarks/programs/jgrapht/log.total.connected_component_enwiki.*.txt ${project_root}/benchmarks/programs/jgrapht/connected_component_enwiki/
	mv ${project_root}/benchmarks/programs/jgrapht/mtime.connected_component_enwiki.*.txt ${project_root}/benchmarks/programs/jgrapht/connected_component_enwiki/
	# produce plots (a few minutes -- logs will be displayed if you run in a graphical UI)
	cd ${project_root}/benchmarks/data && stack runghc -- plot.hs
	# open result file
	echo "Now open ${project_root}/benchmarks/results.html in a browser"
	chromium ${project_root}/benchmarks/results.html 1> /dev/null 2> /dev/null &

.PHONY: plots
plots:
	cd ${project_root}/benchmarks/data && stack runghc -- plot.hs

.PHONY: view
view:
	chromium ${project_root}/benchmarks/results.html 1> /dev/null 2> /dev/null &

.PHONY: zip
zip:
	zip -r results.zip ${project_root}/benchmarks/results.html ${project_root}/benchmarks/data/images/evaluation ${project_root}/benchmarks/data/images/submitted_evaluation

.PHONY: test
test:
	# compile
	cd ${project_root}/benchmarks/programs/synthetic && make
	# run benchmarks
	cd ${project_root}/benchmarks/programs/synthetic && stack runghc -- hcsgc_run.hs benchmark_fast
	# Nullify any non-supported perf's to allow producing the plots
	find ${project_root}/benchmarks/programs/synthetic/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +
	# Move synthetic logs to data directory -- faking iterations!
	for i in `seq 1 31`; do \
		cp ${project_root}/benchmarks/programs/synthetic/log.total.synthetic.1.txt ${project_root}/benchmarks/data/synthetic/log.total.synthetic.$$i.txt; \
		cp ${project_root}/benchmarks/programs/synthetic/mtime.synthetic.1.txt ${project_root}/benchmarks/data/synthetic/mtime.synthetic.$$i.txt; \
	done
	# produce plots
	cd ${project_root}/benchmarks/data && stack runghc -- plot.hs fast
	# open result file
	echo "Now open ${project_root}/benchmarks/results.html in a browser"
	chromium ${project_root}/benchmarks/results.html 1> /dev/null 2> /dev/null &

.PHONY: test_full
test_full:
	# compile
	cd ${project_root}/benchmarks/programs/synthetic && make
	cd ${project_root}/benchmarks/programs/synthetic_cold && make
	cd ${project_root}/benchmarks/programs/synthetic_phases && make
	# run benchmarks
	cd ${project_root}/benchmarks/programs/synthetic && stack runghc -- hcsgc_run.hs benchmark
	cd ${project_root}/benchmarks/programs/synthetic_cold && stack runghc -- hcsgc_run.hs benchmark
	cd ${project_root}/benchmarks/programs/synthetic_phases && stack runghc -- hcsgc_run.hs benchmark
	# Nullify any non-supported perf's to allow producing the plots
	find ${project_root}/benchmarks/programs/synthetic/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +
	find ${project_root}/benchmarks/programs/synthetic_cold/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +
	find ${project_root}/benchmarks/programs/synthetic_phases/ -type f -name "*.txt" -exec sed -i 's/<not supported>/1/g' {} +
	# Move synthetic logs to data directory
	mv ${project_root}/benchmarks/programs/synthetic/log.total.synthetic.*.txt ${project_root}/benchmarks/data/synthetic
	mv ${project_root}/benchmarks/programs/synthetic/mtime.synthetic.*.txt ${project_root}/benchmarks/data/synthetic
	# Move synthetic cold logs to data directory
	mv ${project_root}/benchmarks/programs/synthetic_cold/log.total.synthetic_cold.*.txt ${project_root}/benchmarks/data/synthetic_cold
	mv ${project_root}/benchmarks/programs/synthetic_cold/mtime.synthetic_cold.*.txt ${project_root}/benchmarks/data/synthetic_cold
	# Move synthetic phases logs to data directory
	mv ${project_root}/benchmarks/programs/synthetic_phases/log.total.synthetic_phases.*.txt ${project_root}/benchmarks/data/synthetic_phases
	mv ${project_root}/benchmarks/programs/synthetic_phases/mtime.synthetic_phases.*.txt ${project_root}/benchmarks/data/synthetic_phases
	# produce plots
	cd ${project_root}/benchmarks/data && stack runghc -- plot.hs slow
	# open result file
	echo "Now open ${project_root}/benchmarks/results.html in a browser"
	chromium ${project_root}/benchmarks/results.html 1> /dev/null 2> /dev/null &

.PHONY: clean_results
clean_results:
	rm -f ${project_root}/benchmarks/data/images/evaluation/*.txt
	rm -f ${project_root}/benchmarks/data/images/submitted_evaluation/*.txt
	rm -f ${project_root}/benchmarks/programs/synthetic/*.txt


