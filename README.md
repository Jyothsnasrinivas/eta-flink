
<h1 align="center">Apache Flink example in Eta</h1>

[Apache Flink](https://flink.apache.org/) is a Big Data processing framework that allows programmers to process the vast amount of data in a very efficient and scalable manner.

This is a simple WordCount example in Eta.

**Maven Dependencies**

The maven dependencies for `flink-java` and `flink-clients` are added in the `eta-flink.cabal` file.

```cabal
maven-depends:       org.apache.flink:flink-java:1.2.1, org.apache.flink:flink-clients_2.10:1.2.1

```

The sample text is in the `input.txt` file.

Afterall, we will see results of the Word Count in console and the `output.txt` that is generated.

## Running the sample

1) Fire up the terminal and enter the commands:

  ```
  $ git clone https://github.com/Jyothsnasrinivas/eta-flink.git
  $ cd eta-flink
  $ etlas run
  ```

You will notice the following log in the console.

```bash
...
(1500s,1)
(1960s,1)
(an,1)
(and,3)
...
...
(to,1)
(unknown,1)
(versions,1)
(was,1)
(when,1)

```

**Credits**

This example is inspired from the [Apache Flink Example](http://10minbasics.com/apache-flink-hello-world-java-example/) .
