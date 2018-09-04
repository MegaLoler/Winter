.segment "STARTUP" ; avoids warning
.segment "HEADER"
    .byte "NES", 26, 2, 1 ; 32K PRG, 8K CHR
.segment "CHARS"
    .incbin "bg.chr"
    .incbin "sprites.chr"
.segment "VECTORS"
    .word nmi, reset, irq

.segment "ZEROPAGE"
; GLOBAL VARS
; what mode the game engine is in
engine_mode:	.res 1

.segment "CODE"

;; ENGINE MODES ;;

; routines for each game mode
mode_jump_table:
	.word enter_title_screen

; subroutine to jump to appropriate handler
; indexed by A
jump_mode:
	; double the index value for 16 bit offsets
	asl a
	tax
	; push high byte
	lda mode_jump_table+1, x
	pha
	; push low byte
	lda mode_jump_table, x
	pha
	; push flags
	php
	; jump!
	rti

; enter title screen mode
enter_title_screen:
	rts



;; INTERRUPTS ;;

; vsync
nmi:
	; grab the current mode and jump to the appropriate handler
	lda engine_mode
	jsr jump_mode

	; done
	rti

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
	inx		; x = 0
	stx $2000	; disable nmi
	stx $2001	; disable rendering

; wait for a vblank
@wait:
	bit $2002
	bpl @wait

	; clear ram
	tax		; a = 0
@clear_ram:
	sta $000, x
	sta $100, x
	sta $200, x
	sta $300, x
	sta $400, x
	sta $500, x
	sta $600, x
	sta $700, x
	inx
	bne @clear_ram

	; TODO: init apu

	; init vars
	; set mode to enter title screen
	lda #$00
	sta engine_mode


; wait for a vblank
@wait2:
	bit $2002
	bpl @wait2

	; init ppu
	jsr load_bg_palette
	jsr load_nametable

	; enable ppu
	lda #$08	; enable bg
	sta $2001
	lda #$80	; enable nmi
	sta $2000
	
	
@loop:
	; do nothing forever
	jmp @loop



;; UTIL ;;

load_nametable:
	lda $2002
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	ldx #$0
@loop:
	lda nt_00, x
	sta $2007
	inx
	bne @loop
@loop2:
	lda nt_00+$100, x
	sta $2007
	inx
	bne @loop2
@loop3:
	lda nt_00+$200, x
	sta $2007
	inx
	bne @loop3
@loop4:
	lda nt_00+$300, x
	sta $2007
	inx
	bne @loop4
	rts

load_bg_palette:
	lda $2002
	lda #$3f
	sta $2006
	lda #$00
	sta $2006
	ldx #$0
@loop:
	lda bg_pal_00, x
	sta $2007
	inx
	cpx #$10
	bne @loop
	rts
	



;; ASSETS ;;

; palettes
bg_pal_00:	.incbin "bg.pal"

; nametables
nt_00:	.incbin "test1.nam"
nt_01:	.incbin "test2.nam"
