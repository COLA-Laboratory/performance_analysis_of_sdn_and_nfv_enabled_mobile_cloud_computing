pdflatex diff_lengths.tex
pdfcrop diff_lengths.pdf

pdflatex diff_sdn.tex
pdfcrop diff_sdn.pdf

pdflatex mult_services.tex
pdfcrop mult_services.pdf

pdflatex num_ports.tex
pdfcrop num_ports.pdf

rm *.log
rm *.aux
rm *.fdb_latexmk
rm *.fls
rm *.synctex.gz