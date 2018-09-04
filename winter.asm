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

;; UTILITY MACROS ;;

.macro	load_bg addr
	lda $2002
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	ldx #$0
:
	lda addr, x
	sta $2007
	inx
	bne :-
:
	lda addr+$100, x
	sta $2007
	inx
	bne :-
:
	lda addr+$200, x
	sta $2007
	inx
	bne :-
:
	lda addr+$300, x
	sta $2007
	inx
	bne :-
.endmacro

.macro	load_bg_pal addr
	lda $2002
	lda #$3f
	sta $2006
	lda #$00
	sta $2006
	ldx #$0
:
	lda addr, x
	sta $2007
	inx
	cpx #$10
	bne :-
.endmacro

.macro	vblank_wait
:
	bit $2002
	bpl :-
.endmacro

.macro	enable_ppu
	lda #$08	; enable bg
	sta $2001
	lda #$80	; enable nmi
	sta $2000
.endmacro

.macro	disable_ppu
	lda #$00
	sta $2000	; disable nmi
	sta $2001	; disable rendering
.endmacro
	
.macro	clear_ram
	tax		; a = 0
:
	sta $000, x
	sta $100, x
	sta $200, x
	sta $300, x
	sta $400, x
	sta $500, x
	sta $600, x
	sta $700, x
	inx
	bne :-
.endmacro

.macro	set_game_state state
	lda state
	sta engine_mode
.endmacro




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

	disable_ppu
	vblank_wait
	clear_ram
	; TODO: init apu
	set_game_state #$00
	vblank_wait
	load_bg_pal bg_pal_00
	load_bg nt_01
	enable_ppu
	
@forever:
	; do nothing forever
	jmp @forever




;; ASSETS ;;

; palettes
bg_pal_00:	.incbin "bg.pal"

; nametables
nt_00:	.incbin "test1.nam"
nt_01:	.incbin "test2.nam"
