ROMFONT:	equ 0x3D00;	Start address of the ROM font
DEST:		equ 23629;	The DEST system variable (2 bytes)

org 0x685B

USERFONT: 	defb 0xFC,0x58; Address of user font
OFFS: 		defb 0x00,0x00; Offset of current char in font data
DESTA:		defb 0x00,0x00; Address of a$ array

; Copy1 copies the 8 bytes for the current character from ROMFONT+OFFS 
; to USERFONT+OFFS. The BASIC program pokes the user font address into 
; USERFONT at startup and the offset into OFFS when the current char
; is selected.

Copy1:	ld hl,(USERFONT)
	ld bc, (OFFS)
	add hl,bc
	ld d,h
	ld e,l
	ld hl, ROMFONT
	add hl,bc
	ld bc,8
	ldir
	ret

; CopyAll copies 768 bytes from ROMFONT to USERFONT. 

CopyAll:ld hl,(USERFONT)
	ld d,h
	ld e,l
	ld hl, ROMFONT
	ld bc, $0300
	ldir
	ret

; Decode gets the address of the a$ array in BASIC that was stored in 
; DESTA, and then decodes the bits of the current user character into 
; its 8x8 characters as a space or inverse space character.
; This greatly speeds up the operation versus the BASIC code that does this.

; The address of the a$ variable is obtained by making an assignment to the
; first byte of a$ and then reading the system variable DEST for the address.
; Using DEST is tricky. It is the address of the "variable in assignment", 
; but you have to be careful. You can do `LET a$(1,1)=" "` and then print
; the PEEK of 23629 and 23630 to get the correct address of a$, but if you
; were to try to store that with `LET al=PEEK 23629: LET ah=PEEK 23630` you
; will get the wrong answer since `LET al=` makes the variable in assignment
; as "al" rather than "a$". So, I found what worked was:
;    LET a$(1,1)=CHR$ PEEK 23629
;    LET al=CODE a$(1,1)
;    LET a$(1,1)=CHR$ PEEK 23630
;    LET ah=CODE a$(1,1)
;    LET a$(1,1)=" "
; This makes a$ the variable in assignment just before the PEEK, storing
; the byte in a$(1,1) as a character which we then separately decode into
; another variable. The final trick is that the address of a$ can move 
; during program execution if new vars are made, so you need to update 
; this address before you call the Decode routine.

Decode:	ld hl,(USERFONT)
	ld bc,(OFFS)
	add hl,bc
	ld d,h
	ld e,l
	ld hl,(DESTA)
	ld b,8
bytes:	ld c,b;		Swap new b back into c from below
	ld a,(de);	Get byte
	ld b,8
bits:	rla;		Rotate bits L into carry
	jr nc, space
	ld (hl),0x8F;	Solid block for 1 bit
	jr nextch
space:	ld (hl),0x20;	Space for 0 bit
nextch:	inc hl;		Next char in a$
	djnz bits
	inc de;		Next byte
	ld b,c;		Swap c into b for outer djnz loop
	djnz bytes
	ret

; Check if the user font is blank and return non-zero in BC to BASIC if so
; Not working yet.

isempty:
	ld hl,(USERFONT)
	ld bc, $0300
	add hl, bc; 	Point hl to end of userfont to count down from 
rep:	dec hl;		Next lower font byte
	ld a, (hl);	Get font byte
	jr nz, test;		If byte not 0, return with > 0 in BC
	dec c;		Inner 256-byte loop
	jr nz, rep
	djnz rep;	Outer 3x loop
	ret;		All font bytes zero, return with BC=0
test:	ld b, 0;
	ld c, a;
	ret
end
