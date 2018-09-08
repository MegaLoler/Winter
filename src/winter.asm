.include "nes.inc"
.include "macros.inc"

.segment "STARTUP" ; avoids warning
.segment "HEADER"
    .byte "NES", 26, 2, 1 ; 32K PRG, 8K CHR
.segment "CHARS"
    .incbin "bg.chr"
    .incbin "sprites.chr"
.segment "VECTORS"
    .word nmi, reset, irq




.struct Entity
	identity	.byte
	state		.byte
	life_timer	.word
	x_pos		.word
	y_pos		.word
.endstruct

.struct Level
	; dimensions of the map in metatiles
	width		.byte
	height		.byte

	; all pointers
	palette		.word
	map		.word
	entities	.word
.endstruct




.segment "ZEROPAGE"
; scratch vars
tmp0:		.res 2
tmp1:		.res 2
tmp2:		.res 2
tmp3:		.res 2

; engine state
state:		.res 1

; buttons
pad:		.res 1
pad_press:	.res 1

; 12 bit camera position coordinates
cam_x:		.res 1
cam_y:		.res 1
cam_high:	.res 1	; high=x, low=y

.segment "BSS"
particles:	.res $100	; particle effect table
entities:	.res $200	; entity table
map:		.res $200	; loaded map



.segment "CODE"

; wait until vblank
wait_vblank:
	bit ppustatus
	bpl wait_vblank
	rts

; initialize ram contents to 0
clear_ram:
	lda #$00
	tax
:
	sta page0, x
	; skip stack, because it contains return address lol
	; skip oam page
	sta page3, x
	sta page4, x
	sta page5, x
	sta page6, x
	sta page7, x
	inx
	bne :-
	rts

; initialize the oam contents to off the screen
clear_oam:
	ldx #$ff
	txa	; a = $ff
	inx	; x = 0
:
	sta oam, x
	inx
	bne :-
	rts

; copy up to $100 bytes of data to ppu memory
; tmp0 = source
; tmp1 = ppu destination
; tmp2 = length
copy_ppu:
	; latch the ppu address
	bit ppustatus
	lda tmp1+1
	sta ppuaddr
	lda tmp1
	sta ppuaddr

	; copy full pages first
	ldx #$00	; page index
	jmp next_page
:
	ldy #$00	; byte index
:
	lda (tmp0), y
	sta ppudata
	iny
	bne :-	
	inc tmp0+1	; next page
	inx
next_page:
	cpx tmp2+1
	bne :--
	
	; copy the rest
	jmp next_byte
:
	lda (tmp0), y
	sta ppudata
	iny
next_byte:
	cpy tmp2
	bne :-	
	rts

; copy nametable data to the ppu
; tmp0 = address
load_nametable:
	st16 tmp1, nt0
	st16 tmp2, $400
	jmp copy_ppu	

; copy a background palette into the ppu
; tmp0 = address
load_bg_palette:
	st16 tmp1, palbg
load_bg_palette_skip:
	st16 tmp2, $10
	jmp copy_ppu	

; copy a foreground palette into the ppu
; tmp0 = address
load_fg_palette:
	st16 tmp1, palfg
	jmp load_bg_palette_skip	

; setup the title screen
enter_title:
	; disable ppu
	lda #$00
	sta ppuctrl
	sta ppumask

; for entering the title screen when the ppu is already disabled
enter_title_skip:
	; set the engine state
	lda #$00
	sta state

	; load the title screen nametable
	st16 tmp0, nt_title
	jsr load_nametable

	; load the color palette
	st16 tmp0, bg_pal_title
	jsr load_bg_palette

	; reset scrolling
	lda #$00
	sta ppuscroll
	sta ppuscroll

	; enable the ppu
	lda #$88
	sta ppuctrl
	lda #$08
	sta ppumask
	rts

; on vblank
nmi:
	; grab the current mode and jump to the appropriate handler
	;lda engine_mode
	;jmp jump_mode

; for audio or somethin idk yet
irq:
	rti

; on reset, init
reset:
	; disable irq and decimal mode
	sei
	cld

	; setup stack
	ldx #$ff
	txs

	; disable ppu
	inx	; x = 0
	stx ppuctrl
	stx ppumask

	; wait for vblank
	jsr wait_vblank

	; clear ram and oam
	jsr clear_ram
	jsr clear_oam

	; wait for vblank once more
	jsr wait_vblank

	; and enter the title screen
	jsr enter_title_skip
	
	; do nothing forever
:
	jmp :-




;; ASSETS ;;

; palettes
bg_pal_title:		.incbin "title.pal"
bg_pal_pink:		.incbin "pink.pal"
bg_pal_blue:		.incbin "blue.pal"
sprites_pal:		.incbin "sprites.pal"
sprites_pal_sharp:	.incbin "sprites_sharp.pal"

; nametables
nt_title:		.incbin "title.nam"

; maps

