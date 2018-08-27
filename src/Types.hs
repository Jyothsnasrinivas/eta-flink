{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE TypeFamilies        #-}
{-# LANGUAGE TypeOperators       #-}
{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Types where

import Java

---
data ExecutionEnvironment = ExecutionEnvironment @org.apache.flink.api.java.ExecutionEnvironment
    deriving Class

foreign import java unsafe "@static org.apache.flink.api.java.ExecutionEnvironment.getExecutionEnvironment"
      getExecutionEnvironment :: IO ExecutionEnvironment

foreign import java unsafe readTextFile
    :: JString -> Java ExecutionEnvironment (DataSource JString)

foreign import java unsafe "execute" executeFlink :: Java ExecutionEnvironment JobExecutionResult
---

data DataSet t = DataSet (@org.apache.flink.api.java.DataSet t)
    deriving Class

foreign import java unsafe flatMap :: (t <: Object, r <: Object)
      => FlatMapFunction t r -> Java DataSet (FlatMapOperator t r)

foreign import java unsafe groupBy
    :: (t <: Object) => JIntArray -> Java DataSet (UnsortedGrouping t)

foreign import java unsafe aggregate
    :: (t <: Object) => Aggregations -> Int -> Java DataSet (Aggregateoperator t)

foreign import java unsafe "count" countFlink :: Java DataSet ()

foreign import java unsafe writeAsText :: (t <: Object) => JString -> Java DataSet (DataSink t)
---
data Tuple2 t0 t1 = Tuple2 (org.apache.flink.api.java.tuple.Tuple2 t0 t1)
    deriving Class
---
data FlatMapFunction t o = FlatMapFunction (@org.apache.flink.api.common.functions.FlatMapFunction t o)
    deriving Class
---
data FlatMapOperator in out = FlatMapOperator (@org.apache.flink.api.java.operators.FlatMapOperator in out)
    deriving Class
---
data DataSource out = DataSource (@org.apache.flink.api.java.operators.DataSource out)
    deriving Class
---
data UnsortedGrouping t = UnsortedGrouping (@org.apache.flink.api.java.operators.UnsortedGrouping t)
    deriving Class
---
data Aggregations = Aggregations @org.apache.flink.api.java.aggregation.Aggregations
    deriving Class

type instance Inherits Aggregations = '[Enum Aggregations]

foreign import java unsafe
  "@static @field org.apache.flink.api.java.aggregation.Aggregations.SUM"
  sum :: Aggregations

---
data DataSink t = DataSink (@org.apache.flink.api.java.operators.DataSink t)
    deriving Class

---
data Operator out o = Operator (@org.apache.flink.api.java.operators.Operator out o)
    deriving Class

type instance Inherits (Operator out o) = '[DataSet out]
foreign import java unsafe setParallelism :: (o <: Operator out o) -> Int -> Java Operator o

---
data JobExecutionResult = JobExecutionResult @org.apache.flink.api.common.JobExecutionResult
    deriving Class
