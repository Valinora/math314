QMD := $(wildcard *.qmd)
PDFS := $(QMD:.qmd=.pdf)
HTMLS := $(QMD:.qmd=.html)

.PHONY: all pdf html clean

all: pdf html

pdf: $(PDFS)

html: $(HTMLS)

%.pdf: %.qmd
	quarto render "$<" --to pdf

%.html: %.qmd
	quarto render "$<" --to html

clean:
	rm -rf *_files *.html *.pdf
