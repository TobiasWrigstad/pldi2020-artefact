{-# LANGUAGE CPP #-}

#define DRY

#include "../hcsgc_engine.hs"

prefix = ["-jar specjbb2015.jar -m"]
arguments = []

hcsgc_benchmarking_bms =
  [(Main.prefix, Main.arguments, bm, heap_size) | (bm, heap_size) <- bms]
  where
  bms = [
        ("composite", 65536)
      ]

testing_bms =
  [(Main.prefix, Main.arguments, bm, heap_size) | (bm, heap_size) <- bms]
  where
  bms = [
        ("composite", 8192)
      ]

main_run_debug = main_testing [is_debug] 1
main_run_release = main_testing [is_release] 1
main_run_full = main_testing [is_debug `env_or` is_release] 1
main_run_hcsgc_benchmark = main_hcsgc_benchmark
  [ not . use_gtime
  , not . use_gc_log
  , not . use_perf
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
