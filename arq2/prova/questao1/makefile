# LaTeX Makefile
FILE=questao1

all: $(FILE).pdf

$(FILE).pdf: $(FILE).tex
	pdflatex $(FILE)
	bibtex $(FILE)
	pdflatex $(FILE)
	pdflatex $(FILE)

.PHONY: clean
clean:
	rm -v *.aux *.blg *.bbl *.log
