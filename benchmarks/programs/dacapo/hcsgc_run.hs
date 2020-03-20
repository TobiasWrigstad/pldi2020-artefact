{-# LANGUAGE CPP #-}

-- #define DRY

#include "../hcsgc_engine.hs"

prefix = ["-jar dacapo-9.12-MR1-bach.jar -n 25"]

hcsgc_benchmarking_bms =
  [(Main.prefix, args, bm, heap_size) | (bm, heap_size, args) <- bms]
  where
  bms = [
        ("tradebeans", 4096, ["-s huge"])
        , ("h2", 4096, ["-s huge"])
        ]

testing_bms =
  [(prefix, [], bm, heap_size) | (bm, heap_size) <- bms]
  where
  prefix = ["-jar dacapo-9.12-MR1-bach.jar -n 1"]
  bms = [
        ("tradebeans", 4096)
      -- , ("h2", 4096)
      -- , ("jython", 2000)
      -- , ("sunflow", 400)
      -- , ("xalan", 400)
      -- , ("lusearch-fix", 300)
      -- , ("pmd", 220)
      -- , ("fop", 180)
      -- , ("luindex",150 )
      -- , ("avrora", 65)
      ]

main_run_debug = main_testing [ is_debug
                              ] 1
main_run_release = main_testing [is_release] 1
main_run_full = main_testing [is_debug `env_or` is_release] 100
main_run_hcsgc_benchmark = main_hcsgc_benchmark
  [ not . use_gtime
  , use_perf
  , use_gc_log
  ] 5

main = do
  sh $ rm_dump
  arg <- getArgs
  sh $ case arg of
      ["debug"] -> main_run_debug
      ["release"] -> main_run_release
      ["full"] -> main_run_full
      ["benchmark"] -> main_run_hcsgc_benchmark
  return ()
