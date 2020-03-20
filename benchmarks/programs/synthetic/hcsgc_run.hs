{-# LANGUAGE CPP #-}

-- #define DRY

#include "../hcsgc_engine.hs"

prefix = []
arguments = []

mybms = [
      ("synthetic", 400)
        -- , ("synthetic_cold", 1400)
        -- , ("synthetic_phases", 400)
    ]
hcsgc_benchmarking_bms =
  [(Main.prefix, Main.arguments, bm, heap_size) | (bm, heap_size) <- bms]
    where bms = mybms

testing_bms =
  [(Main.prefix, Main.arguments, bm, heap_size) | (bm, heap_size) <- bms]
    where bms = mybms

main_run_debug = main_testing [is_debug] 1
main_run_release = main_testing [is_release] 1
main_run_full = main_testing [is_debug `env_or` is_release] 1
main_run_hcsgc_benchmark = main_hcsgc_benchmark
    [ use_gtime
    , use_perf
    , use_gc_log
    -- , \e -> cold_confidence e > 0
    -- , not . use_cold_page
    ]

main = do
  sh $ rm_dump
  arg <- getArgs
  sh $ case arg of
      ["debug"] -> main_run_debug
      ["release"] -> main_run_release
      ["full"] -> main_run_full
      ["benchmark"] -> main_run_hcsgc_benchmark 31
      ["benchmark_fast"] -> main_run_hcsgc_benchmark 1
  return ()
