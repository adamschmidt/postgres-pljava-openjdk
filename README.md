# postgres-pljava-openjdk
Based on the image [xxBedy/postgres-pljava](https://github.com/xxBedy/postgres-pljava) but using openjdk as oracle jdk is not redistributable without first accepting the end-user license.

Furthermore, this image has been optimized to be as small as possible. The aforementioned image this was based on currently sits at 1.4GB. This image, after the various optimizations made (we're not squashing), is just shy of 450MB.

Image can be found here: [pegasystems/postgres-pljava-openjdk](https://hub.docker.com/r/pegasystems/postgres-pljava-openjdk/)

# Postgres JVM Options

The image has been extended to include [confd](https://github.com/kelseyhightower/confd) to enable configuring JVM parameters on startup.

At present, JVM parameters can be configured by passing the following environment variables into the container `run` command:

* `POSTGRES_PLJAVA_VMOPTIONS`: Standard JVM options argument (sets `pljava.vmoptions` in Postgres configuration). Defaults to `-Xms32M -Xmx64M -XX:ParallelGCThreads=2` if not supplied
* `POSTGRES_WORK_MEM`: working memory size (sets `work_mem` in Postgres configuration). Defaults to `5MB` if not supplied
