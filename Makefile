
qf: qf.tap

qfa: QuickFont.tap

mc: qf_mc.bin

dck: QuickFont.dck

os64: QuickFont_OS64.tap

dist: Quickfont.zip

loader: FontLoader.tap

tildebar: tildebar.tap

doc: README.html

qf.tap: QuickFont_zmb.bas
	cp qf.tap qf_prev.tap || echo "Making qf.tap"
	zmakebas -o qf.tap -n quickfont QuickFont_zmb.bas
	listbasic qf.tap > qf.bas
	grep -v -E "^\s*$$" QuickFont_zmb.bas | grep -v -E "^#" | diff --ignore-trailing-space - qf.bas || echo "WARNING: listbasic version differs from zmakebas version"

QuickFont.tap: QuickFont_zmb.bas
	cp QuickFont.tap QuickFont_prev.tap
	zmakebas -a 1 -o QuickFont.tap -n quickfont QuickFont_zmb.bas
	listbasic QuickFont.tap > QuickFont.bas
	grep -v -E "^\s*$$" QuickFont_zmb.bas | grep -v -E "^#" | diff --ignore-trailing-space - QuickFont.bas || echo "WARNING: listbasic version differs from zmakebas version"

Quickfont.zip: QuickFont.tap README.html
	rm -f QuickFont.zip
	zip -j QuickFont.zip QuickFont.tap QuickFont.dck QuickFont.bas README.html *.png ../github/fonts/*_font.tap ../FontLoader.tap ../FontLoader.bas ../tildebar.tap ../tildebar.bas

README.html: README.md
	pandoc -s -o README.html README.md

QuickFont_OS64.tap: QuickFont_OS64.bas
	zmakebas -a 1 -o QuickFont_OS64.tap -n quickfont QuickFont_OS64.bas

QuickFont.dck: QuickFont.tap

qf_mc.bin: qf_mc.asm
	z80asm -o qf_mc.bin --list=qf_mc.txt qf_mc.asm && hexdump -v -e '16/1 "%02X ""\n"' qf_mc.bin

%.tap: %.bas
	zmakebas -n $* -o $@ $<

%.dck: %.tap
	tap2cart $<
	rm $*.bin
