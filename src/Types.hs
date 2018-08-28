{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE TypeFamilies        #-}
{-# LANGUAGE TypeOperators       #-}
{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE AllowAmbiguousTypes #-}

module Types where

import Java

---
data ExecutionEnvironment = ExecutionEnvironment @org.apache.flink.api.java.ExecutionEnvironment
    deriving Class

foreign import java unsafe "@static org.apache.flink.api.java.ExecutionEnvironment.getExecutionEnvironment"
      getExecutionEnvironment :: Java a ExecutionEnvironment

foreign import java unsafe readTextFile
    :: JString -> Java ExecutionEnvironment (DataSource JString)

foreign import java unsafe "execute" executeFlink :: JString -> Java ExecutionEnvironment JobExecutionResult
---

data DataSet t = DataSet (@org.apache.flink.api.java.DataSet t)
    deriving Class

foreign import java unsafe flatMap :: (t <: Object, r <: Object, a <: DataSet t) =>
    FlatMapFunction t r -> Java a (FlatMapOperator t r)

foreign import java unsafe groupBy
    :: (t <: Object, a <: DataSet t) => JIntArray -> Java a (UnsortedGrouping t)

-- foreign import java unsafe aggregate
--     :: (a <: DataSet t) => Aggregations -> Int -> Java a (AggregateOperator t)

foreign import java unsafe "count" countFlink :: (a <: DataSet t) => Java a ()

foreign import java unsafe "print" printFlink :: (a <: DataSet t) => Java a ()

foreign import java unsafe writeAsText :: (t <: Object, a <: DataSet t)
      => JString -> Java a (DataSink t)
---
data Tuple2 t0 t1 = Tuple2 (@org.apache.flink.api.java.tuple.Tuple2 t0 t1)
    deriving Class

foreign import java unsafe "@new" newTuple2 :: (t0 <: Object, t1 <: Object)
  => t0 -> t1 -> Java a (Tuple2 t0 t1)
---
data FlatMapFunction t o = FlatMapFunction (@org.apache.flink.api.common.functions.FlatMapFunction t o)
    deriving Class

foreign import java unsafe "@wrapper flatMap" mkFlatMap :: (t <: Object, o <: Object)
      => (t -> Collector o -> Java (FlatMapFunction t o) ()) -> FlatMapFunction t o
---
data FlatMapOperator t o = FlatMapOperator (@org.apache.flink.api.java.operators.FlatMapOperator t o)
    deriving Class

type instance Inherits (FlatMapOperator t o) = '[SingleInputUdfOperator t o (FlatMapOperator t o)]

---
data DataSource o = DataSource (@org.apache.flink.api.java.operators.DataSource o)
    deriving Class

type instance Inherits (DataSource o) = '[Operator o (DataSource o)]
---
data UnsortedGrouping t = UnsortedGrouping (@org.apache.flink.api.java.operators.UnsortedGrouping t)
    deriving Class

type instance Inherits (UnsortedGrouping t) = '[Grouping t]

foreign import java unsafe aggregate :: (t <: Object)
    => Aggregations -> Int -> Java (UnsortedGrouping t) (AggregateOperator t)
---

data Grouping t = Grouping (@org.apache.flink.api.java.operators.Grouping t)
    deriving Class

---
data Aggregations = Aggregations @org.apache.flink.api.java.aggregation.Aggregations
    deriving Class

-- type instance Inherits Aggregations = '[Enum Aggregations]

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

foreign import java unsafe setParallelism :: Int -> Java (DataSink t) (DataSink t)

---
data JobExecutionResult = JobExecutionResult @org.apache.flink.api.common.JobExecutionResult
    deriving Class
----
data Collector t = Collector (@org.apache.flink.util.Collector t)
    deriving Class

foreign import java unsafe "@interface" collect :: (t <: Object)
    => t -> Java (Collector t) ()
---
data AggregateOperator t = AggregateOperator (@org.apache.flink.api.java.operators.AggregateOperator t)
    deriving Class

type instance Inherits (AggregateOperator t) = '[Operator t (AggregateOperator t)]

foreign import java unsafe toLowerCase :: JString -> JString

---
data SingleInputUdfOperator t out o =  SingleInputUdfOperator (@org.apache.flink.api.java.operators.SingleInputUdfOperator t out o)
    deriving Class

type instance Inherits (SingleInputUdfOperator t out o) = '[Operator out o]

foreign import java unsafe returns :: (a <: SingleInputUdfOperator t out o, o <: SingleInputUdfOperator t out o)
  => JString -> Java a o
