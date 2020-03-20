{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import System.Environment (getArgs)
import qualified Data.Text as DT
import Turtle as T hiding (env)

-- #define DRY

#ifdef DRY
dry_run = True
#else
dry_run = False
#endif

zshell cmd =
  shell (format ("/usr/bin/zsh -c \"" %s% "\"") cmd)

my_select = select . filter (not . DT.null)

run_cmd :: Text -> Shell ()
run_cmd cmd = do
  echo $ unsafeTextToLine cmd
  -- fst <$> shellStrict cmd T.empty .||. die "sth went wrong"
  if dry_run
     then return ()
     else do
          _ <- zshell cmd T.empty .||. die "sth went wrong"
          return ()

process_synthetic_fast = do
  bm <- my_select bms
  cd $ fromText bm
  run_cmd "ruby ../perf.rb"
  run_cmd $ format ("octave ../hcsgc_benchmark.m " %s) bm
  cd ".."
  where
  bms = [ ""
        , "synthetic"
        ]

process_synthetic = do
  bm <- my_select bms
  cd $ fromText bm
  run_cmd "ruby ../perf.rb"
  run_cmd $ format ("octave ../hcsgc_benchmark.m " %s) bm
  cd ".."
  where
  bms = [ ""
        , "synthetic"
        , "synthetic_cold"
        , "synthetic_phases"
        ]

process_jgrapht = do
  bm <- my_select bms
  cd $ "jgrapht"
  cd $ fromText bm
  run_cmd "ruby ../../perf.rb"
  run_cmd $ format ("octave ../../hcsgc_benchmark.m " %s) bm
  cd "../.."
  where
  bms = [ ""
        , "connected_component_uk"
        , "connected_component_enwiki"
        , "maximal_clique_uk"
        , "maximal_clique_enwiki"
        ]

process_dacapo = do
  bm <- my_select bms
  cd "dacapo"
  cd $ fromText bm
  run_cmd "ruby ../dacapo.rb "
  run_cmd $ format ("octave ../dacapo.m " %s) bm
  cd "../.."
  where
    bms = [ ""
          , "h2"
          , "tradebeans"
          ]

process_specjbb = do
  cd "specjbb"
  run_cmd $ format ("./extract.sh " %d) loop_max
  run_cmd $ "ruby ./specjbb.rb "
  run_cmd $ format ("octave ./specjbb.m " %d) loop_max
  cd ".."
  where
    loop_max = 5

process_all =
  msum [ return ()
       , process_synthetic
       , process_jgrapht
       , process_dacapo
       -- , process_specjbb
  ]

main = do
  arg <- getArgs
  sh $ case arg of
      ["fast"] -> process_synthetic_fast
      ["slow"] -> process_synthetic
      _ -> process_all
  return ()
