{-# LANGUAGE OverloadedStrings #-}

module Main where

import Java
import Types
import Prelude hiding (sum)
import Control.Monad (forM_, when)
import qualified Interop.Java.StringUtils as JS

main :: IO ()
main = java $ do
    env <- getExecutionEnvironment
    sampleData <- env <.> readTextFile "input.txt"
    counts <- sampleData <.> flatMap (mkFlatMap lineSplitter)
                >- returns "Tuple2<String,Integer>"
                >- groupBy (toJava [0 :: Int])
                >- (aggregate sum 1)
    counts <.> printFlink
    counts <.> writeAsText "output.txt" >- setParallelism 1
    env <.> executeFlink "WordCount Example"
    return ()

    where  lineSplitter :: JString -> Collector (Tuple2 JString JInteger)
                       -> Java (FlatMapFunction JString (Tuple2 JString JInteger)) ()
           lineSplitter value out = do
              let tokens = flip JS.split "\\W+" $ toLowerCase value
                  jstrings = fromJava tokens :: [JString]
              forM_ jstrings $ \token -> do
                when (JS.length token > 0) $ do
                  tupleFlink <- (newTuple2 token (toJava (1 :: Int) :: JInteger))
                  out <.> collect tupleFlink
