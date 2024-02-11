ROMFONT:	equ 0x3D00;	Start address of the ROM font (different for OS-64)
DEST:		equ 23629;	The DEST system variable (2 bytes): Address of variable in assignment
CHARS:		equ 23606;	The CHARS system variable (2 bytes): Address of font - 256 bytes
UDG:		equ 23675;  The UDG system variable (2 bytes): Address of UDGs

org 0x0000

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

Decode:
	ld hl,(CHARS)
	inc h
	ld bc,$FFFF;	Will poke OFFS here
	add hl,bc
	ld d,h
	ld e,l
	ld hl,$FFFF;	Will poke DEST of a$ here
	ld b,8
bytes:
	ld c,b;		Swap new b back into c from below
	ld a,(de);	Get byte
	ld b,8
bits:
	rla;		Rotate bits L into carry
	jr nc, space
	ld (hl),0x8F;	Solid block for 1 bit
	jr nextch
space:
	ld (hl),0x20;	Space for 0 bit
nextch:
	inc hl;		Next char in a$
	djnz bits
	inc de;		Next byte
	ld b,c;		Swap c into b for outer djnz loop
	djnz bytes
	ret

; CopyAll copies 768 bytes from ROMFONT to USERFONT. 

CopyAll:
	ld hl,(CHARS)
	inc h
	ld d,h;			de points to user font
	ld e,l
	ld hl, ROMFONT;	hl points to ROM font
	ld bc, $0300;	96*8 bytes
	ldir;			Copy bytes from ROM font to user font
	ret

; Swaps 21*8 bytes between the UDGs and the user font chars A-U

UDG2font:
	ld hl,(CHARS)
	ld bc, 520;		(65(A)-32(space))*8 + 256
	add hl, bc
	ld d,h; 		de points to A in user font
	ld e,l
	ld hl, (UDG);	hl points to UDGs
	ld b, 168; 		21*8 bytes
u2f:ld a,(de);		Get font byte
	ld c,a;			Save it in c
	ld a,(hl);		Get UDG byte
	ld (de),a;		Save it to font
	ld (hl),c;		Put font byte in UDG
	inc de
	inc hl;			Point to next bytes
	djnz u2f;		Next byte
	ret

; Not yet using this MC for flips and rotates
; I was having trouble in the emulator getting some of this to work,
; so I'm going to to pass on it for now.

fliph:
	ld bc,$FFFF;	Will poke offset here
	ld hl,(CHARS)
	inc h
	add hl,bc;		hl has char addr
	ld b,8
fliph8:
	ld c,b
	ld d,(hl);		Get byte
	ld b,8
fliph1:
	rr d;			Bit0 to carry...
	rla;			...carry into bit 0 of a
	djnz fliph1
	ld (hl),a;		Put flipped byte back
	inc hl;			Next byte
	ld b,c;			Swap c into b for outer djnz loop
	djnz fliph8
	ret
	
rotL:
	ld bc,$FFFF;	Will poke offset here
	ld hl,(CHARS)
	inc h
	add hl,bc;		hl has char addr
	ld bc,8
	add hl,bc;		point to last byte+1
	ld b,8
rotL80:
	dec hl
	ld a,(hl)
	push af			; Push 8 bytes to stack
	xor a
	ld (hl),a		; Zero the byte
	djnz rotL80
	ld b,8			; 8 bytes
rotL8:
	ld c,b
	pop de			; Get byte
	ld b,8			; Process its 8 bits
rotL1:
	ld a,(hl)		; Get new byte
	rr d;			Bit0 to carry...
	rla;			...carry into bit 0 of a
	ld (hl),a		; Put back
	inc hl
	djnz rotL1
	ld b,8			; Point hl back to byte0
rotL18:
	dec hl
	djnz rotL18
	ld b,c;			Swap c into b for outer djnz loop
	djnz rotL8
	ret

rotT:
	ld bc,$FFFF;	Will poke offset here
	ld hl,(CHARS)
	inc h
	add hl,bc;		hl has char addr
	ld bc,8
	add hl,bc;		point to last byte+1
	ld b,8
rotT80:
	dec hl
	djnz rotT80
	ld b,h
	ld c,l
	ret
	
end
