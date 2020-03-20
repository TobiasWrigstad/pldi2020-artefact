{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import System.Environment (getArgs)
import Control.Monad (liftM2)
import qualified Data.Text as DT
import Turtle as T hiding (env)

default (DT.Text, Integer)

type BM = Text

#ifdef DRY
dry_run = True
#else
dry_run = False
#endif

zshell cmd =
  shell (format ("/usr/bin/zsh -c \"" %s% "\"") cmd)

run_cmd :: Text -> Shell ()
run_cmd cmd = do
  echo $ unsafeTextToLine cmd
  -- fst <$> shellStrict cmd T.empty .||. die "sth went wrong"
  if dry_run
     then return ()
     else do
          _ <- zshell cmd T.empty .||. die "sth went wrong"
          return ()

rm_dump :: Shell ()
rm_dump = do
  run_cmd "rm -f core"
  run_cmd "rm -f hs_*.log || true"
  run_cmd "rm -f replay*.log || true"
  return ()

ode_prefix = "~/paper99/openjdk/build/linux-x86_64-server-fastdebug/jdk/bin/"
ore_prefix = "~/paper99/openjdk/build/linux-x86_64-server-release/jdk/bin/"

de_prefix = "~/paper99/hcsgc/build/linux-x86_64-server-fastdebug/jdk/bin/"
re_prefix = "~/paper99/hcsgc/build/linux-x86_64-server-release/jdk/bin/"

dejava = de_prefix <> "java"
rejava = re_prefix <> "java"
odejava = ode_prefix <> "java"
orejava = ore_prefix <> "java"

data Config = Debug | Release deriving (Show, Eq)

data Env = Env { hot_cycle :: Integer
               , cold_confidence :: Integer
               , use_relocate_all_small_pages :: Bool
               , use_cold_page :: Bool
               , use_lazy_relocate :: Bool
               , config :: Config
               , use_original_java :: Bool
               , use_gtime :: Bool
               , use_gc_log :: Bool
               , use_perf :: Bool
               }

is_release = (== Release) . config
is_debug = (== Debug) . config
env_or :: (Env -> Bool) -> (Env -> Bool) -> (Env -> Bool)
env_or f1 f2 = liftM2 (||) f1 f2
empty_cmd = run_cmd ""

main_hcsgc_benchmark conds loops = do
  msum [ empty_cmd
       , run_all
       -- , plot_all
       ]
  where
    reset_log_files bm = do
      run_cmd $ format ("cat /dev/null > mtime." %s% ".*txt || true") bm
      run_cmd $ format ("cat /dev/null > log.*." %s% ".*txt || true") bm

    run_all = do
      (prefix, arguments, bm, heap_size) <- select hcsgc_benchmarking_bms
      printf ("BM: " %s% "\n") bm
      _ <- reset_log_files bm
      env <- select $ filter cond $ concat $
                               [ []
                               , ozgc_envs
                               , hcsgc_envs
                               ]
      loop <- select [1..loops]
      per_bm env prefix arguments bm heap_size loop
      where
        cond = combine_conds $ [ \_ -> True
                             , is_release
                             ] ++ conds
    plot_all = run_cmd $ "xvfb-run -a octave hcsgc_benchmark.m"

main_testing conds loops = do
    msum [ empty_cmd
         , run_all
         ]
    where
      run_all = do
        loop <- select [1..loops]
        (prefix, arguments, bm, heap_size) <- select testing_bms
        printf ("Loop: " %d% " BM: " %s% "\n") loop bm
        env <- select $ filter cond $ concat $
                                             [ []
                                             , hcsgc_envs
                                             ]
        per_bm env prefix arguments bm heap_size 0
        where
          cond = combine_conds $ [ \_ -> True
                               , not . use_gtime
                               , not . use_gc_log
                               , not . use_perf
                               ] ++ conds

combine_conds :: [(a -> Bool)] -> a -> Bool
combine_conds [] _ = True
combine_conds (c:cs) element = c element && combine_conds cs element

hot_cycles = [0..1]

ozgc_envs =
  [Env{ hot_cycle = 0
      , cold_confidence = 0
      , use_relocate_all_small_pages = False
      , use_cold_page = False
      , use_lazy_relocate = False
      , config = Release
      , use_original_java = True
      , use_gtime
      , use_gc_log
      , use_perf
      } | use_gtime <- [True, False]
        , use_gc_log <- [True, False]
        , use_perf <- [True, False]
        ]

hcsgc_envs = do
  hot_cycle <- hot_cycles
  use_relocate_all_small_pages <- [False, True]
  use_cold_page <- if hot_cycle == 0
                   then [False]
                   else if use_relocate_all_small_pages
                        then [True]
                        else [False, True]
  use_lazy_relocate <- [False, True]
  cold_confidence <- if hot_cycle > 0 && not use_relocate_all_small_pages
                     then [0, 50, 100]
                     else [0]
  config <- [Debug, Release]
  use_original_java <- [False]
  use_gtime <- [False, True]
  use_gc_log <- [False, True]
  use_perf <- [False, True]
  return $ Env{..}

per_bm Env{..} prefix arguments bm heap_size loop = do
  run_cmd action
  where
  list_to_str = DT.intercalate " " . filter (not . DT.null)
  action = list_to_str
    [ "{sleep 1;"
    , dump_core
    , wall_clock_time
    , perf
    -- , "taskset -c 1"
    , java
    , format ("-Xms" %d% "m") heap_size
    , format ("-Xmx" %d% "m") heap_size
    , "-XX:+UnlockExperimentalVMOptions -XX:+UseZGC"
    , hot_cycle_arg
    -- , min_relocatable_age_arg
    , relocate_all_small_pages
    , cold_page
    , cold_confidence_arg
    , lazy_relocate
    , logg
    , list_to_str prefix
    , bm
    , list_to_str arguments
    -- , "-s large"
    -- , "--sizes"
    , capture_stdout
    , assemble_stdout
    , assemble_wct
    ]
  dump_core | config == Debug = "ulimit -c unlimited;"
            | otherwise = ""
  -- dump_core = "ulimit -c unlimited;"
  capture_stdout = "} &> tmp.log.txt;"
  assemble_stdout | use_gc_log = format ("cat tmp.log.txt >> log.total." %s% "." %d% ".txt;") bm loop
                  | otherwise = ""
  wall_clock_time | use_gtime = "/usr/bin/time -f '%e' -o tmp.time.txt"
                  | otherwise = ""
  perf | use_perf = "perf stat -e L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses"
       | otherwise = ""
  assemble_wct | use_gtime = format ("cat tmp.time.txt >> mtime." %s% "." %d% ".txt;") bm loop
               | otherwise = ""
  java = java' config use_original_java
    where
      java' Debug True = odejava
      java' Release True = orejava
      java' Debug False = dejava
      java' Release False = rejava
  relocate_all_small_pages = if use_relocate_all_small_pages
                             then "-XX:+UseRelocateAllSmallPages"
                             else ""
  hot_cycle_arg = if not use_original_java
                     then format ("-XX:HotCycles=" %d% "") hot_cycle
                     else ""
  min_relocatable_age_arg = if not use_original_java
                     then format ("-XX:MinRelocatableAge=" %d% "") 2
                     else ""
  cold_confidence_arg = if not use_original_java
                           then format ("-XX:ColdConfidence=" %d) cold_confidence
                           else ""
  cold_page = if use_cold_page then "-XX:+UseColdPage" else ""
  lazy_relocate = if use_lazy_relocate then "-XX:+UseLazyRelocate" else ""
  logg | use_gc_log = "-Xlog:gc"
       | otherwise = ""
