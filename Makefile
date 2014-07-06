all: clean config compile test package main

config:
	if ! [ -d ~/.m2/repository/com/declarativa ]; then wget http://www.lusio.it/interprolog.jar; mvn install:install-file -Dfile=interprolog.jar -DgroupId=com.declarativa.interprolog -DartifactId=interprolog -Dversion=2.2a4 -Dpackaging=jar; rm interprolog.jar; fi

main:
	mvn -T 4 exec:java -Dexec.mainClass="it.uniba.di.ia.ius.Main"

compile:
	mvn -T 4 compile

test:
	mvn -T 4 test

package:
	mvn -T 4 package

clean:
	mvn clean



