
mcode: mcode.z80
	z80asm -l -o mcode.bin mcode.asm > mcode.txt

qf: QuickFont.tap

qf64: QuickFont_OS64.tap

loader: FontLoader.tap

tildebar: tildebar.tap

dck: QuickFont.dck

%.tap: %.bas
	zmakebas -n $* -o $@ $<

%.dck: %.tap
	tap2cart $<
	rm $*.bin

package: QuickFont.tap QuickFont.dck QuickFont_OS64.tap FontLoader.tap tildebar.tap
	zip -j QuickFont.zip QuickFont.tap QuickFont.dck QuickFont.bas QuickFont_OS64.tap QuickFont_OS64.bas fonts/*.tap FontLoader.tap FontLoader.bas tildebar.tap tildebar.bas
