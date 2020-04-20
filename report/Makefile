
default:
	pandoc report.md --template eisvogel.tex -o report.pdf --from markdown+footnotes --listings -V lang=fr --toc --number-sections

.PHONY: clean

clean:
	rm report.pdf
