MAINFILE=main

all : pdf

pdf	: clean
	pdflatex -shell-escape ${MAINFILE}.tex
	pdflatex -shell-escape ${MAINFILE}-frn.tex
	bibtex ${MAINFILE}
	pdflatex -shell-escape ${MAINFILE}
	pdflatex -shell-escape ${MAINFILE}
	evince ${MAINFILE}.pdf&

clean	:
	  -rm -f *.snm *.nav *.out *.log *.aux *.dvi *.bbl *.blg *.ilg *.toc *.lof *.lot *.idx *.ind *.ps *~

gedit:
	pdflatex -shell-escape --synctex=1 ${MAINFILE}.tex
	pdflatex -shell-escape --synctex=1 ${MAINFILE}-frn.tex
	bibtex ${MAINFILE}
	pdflatex -shell-escape --synctex=1 ${MAINFILE}
	
