module Main where

import Java
import Types

main :: IO ()
main = java $ do
    env <- ExecutionEnvironment <.> getExecutionEnvironment
    sampleData <- env <.> readTextFile "TODO"
    counts <- sampleData <.> flatMap (line LineSplitter)
                <.> groupBy [0]
                <.> aggregate Aggregations.sum 1
    counts <.> printFlink
    counts <.> writeAsText "TODO" <.> setParallelism 1
    env <.> executeFlink "WordCount Example"

    where line = do
              flatMap value out
              tokens <- value ---TODO
