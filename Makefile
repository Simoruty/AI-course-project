all: clean compile test package yap

yap:
	mvn -T 4 exec:java -Dexec.mainClass="it.uniba.di.ia.ius.MainYAP"

swi:
	mvn -T 4 exec:java -Dexec.mainClass="it.uniba.di.ia.ius.MainSWI"

compile:
	mvn -T 4 compile

test:
	mvn -T 4 test

package:
	mvn -T 4 package

clean:
	mvn clean



