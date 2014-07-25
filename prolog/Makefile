all: run

run:
	./run.sh

yap:
	yap -l main.pl

swi:
	swipl -f main.pl

swirun:
	swipl -l main.pl -g start,halt -t 'halt(0)'

image: swirun
	dot -Tpng ../var/all.dot > ../var/all.png
	eog ../var/all.png &

images: swirun
	for f in `ls ../var/spiegazioni/*.dot`; do dot -Tpng $$f > "$$(echo $$f|sed 's/dot/png/')"; done
	eog ../var/spiegazioni/tag0.png 2>&1 > /dev/null &

dataset:
	java -cp ../target/classes/ it.uniba.di.ia.ius.GeneratoreDataset $(numDoc)
