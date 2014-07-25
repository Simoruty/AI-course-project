all: run

run:
	./run.sh

yap:
	yap -l main.pl

swi:
	swipl -f main.pl

swirun:
	swipl -l main.pl -g start,halt -t 'halt(0)'
	for f in `ls spiegazioni/*.dot`; do dot -Tpng $$f > "$$(echo $$f|sed 's/dot/png/')"; done
	eog spiegazioni/tag0.png 2>&1 > /dev/null &
