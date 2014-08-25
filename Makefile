numDoc=1

all: run

prepare: clean config compile test package dataset

config:
	if ! [ -d ~/.m2/repository/com/declarativa ]; then wget http://www.lusio.it/interprolog.jar; mvn install:install-file -Dfile=interprolog.jar -DgroupId=com.declarativa.interprolog -DartifactId=interprolog -Dversion=2.2a4 -Dpackaging=jar; rm interprolog.jar; fi

run:
	mvn -T 4 exec:java -Dexec.mainClass="it.uniba.di.ia.ius.Main"

dataset:
	mvn -T 4 exec:java -Dexec.mainClass="it.uniba.di.ia.ius.GeneratoreDataset" -Dexec.args="$(numDoc)"

compile:
	mvn -T 4 compile

test:
	mvn -T 4 test

package:
	mvn -T 4 package

clean: cleanGraph
	rm -f prolog/dataset.pl
	mvn clean

cleanGraph:
	rm -f graph/*.dot
	rm -f img/*.png

yap:
	yap -l prolog/main.pl

swi:
	swipl -f prolog/main.pl

swirun:
	swipl -f prolog/main.pl -g main,halt -t 'halt(0)'

yaprun:
	yap -l prolog/main.pl -g main,halt -t 'halt(0)'

images: cleanGraph yaprun
	for f in `ls graph/d*.dot`; do dot -Tpng $$f > "$$(echo $$f|sed 's/dot/png/'|sed 's/graph/img/')"; done
	eog img/doc0.png 2>&1 > /dev/null &

img_spiegazioni: cleanGraph yaprun
	for f in `ls graph/t*.dot`; do dot -Tpng $$f > "$$(echo $$f|sed 's/dot/png/'|sed 's/graph/img/')"; done
	eog img/tag0.png 2>&1 > /dev/null &
