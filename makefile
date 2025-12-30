
MAIN=elementary-math-note

TEXMAINDOC=elementary-math-note

TEMPFILECLASS=\
*.log \
*.aux \
*.blg \
*.bbl \
*.lof \
*.toc \
*.lot \
*.out \

LATEXCMD=xelatex
#LATEXCMD=lualatex

LATEXOPTIONS=-file-line-error -synctex=1 -interaction=nonstopmode

PDFVIEWER=evince

$(MAIN).pdf : prev
	$(LATEXCMD) $(LATEXOPTIONS) $(TEXMAINDOC)

prev:
	$(LATEXCMD) $(LATEXOPTIONS) $(TEXMAINDOC)

viewpdf : $(MAIN).pdf
	$(PDFVIEWER) $(MAIN).pdf &

clean :
	rm -f $(TEMPFILECLASS)
