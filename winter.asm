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
level_pal:	.res 1
notes_pal:	.res 1

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

.macro	load_fg_pal addr
	lda $2002
	lda #$3f
	sta $2006
	lda #$10
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

.macro	set_level_pal pal
	lda pal
	sta level_pal
.endmacro

.macro	set_notes_pal pal
	lda pal
	sta notes_pal
.endmacro

.macro	set_scroll x_scroll, y_scroll
	; reset scroll address latch by reading status
	lda $2002
	; write x scroll
	lda x_scroll
	sta $2005
	; write y scroll
	lda y_scroll
	sta $2005
.endmacro




;; ENGINE MODES ;;

; entering the title screen will init the whole system as well...basicaly
.macro enter_title_screen
	disable_ppu
	vblank_wait
	clear_ram
	; TODO: init apu
	set_game_state #0
	vblank_wait
	load_bg_pal bg_pal_00
	load_bg nt_00
	enable_ppu
.endmacro

.macro enter_game
	disable_ppu
	vblank_wait
	set_game_state #1
	vblank_wait
	set_level_pal #2
	set_notes_pal #0
	load_bg_pal bg_pal_gold
	load_bg nt_02
	enable_ppu
.endmacro

; routines for each game mode
mode_jump_table:
	.word title_screen
	.word in_game

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

; title screen mode
title_screen:
	;enter_game
	rti

; update the level palatte accordingly
update_level_pal:
	lda level_pal
	and #3
	cmp #0
	bne @skip0
	load_bg_pal bg_pal_gold
	rts
@skip0:
	cmp #1
	bne @skip1
	load_bg_pal bg_pal_blue
	rts
@skip1:
	cmp #2
	bne @skip2
	load_bg_pal bg_pal_pink
	rts
@skip2:
	cmp #3
	bne @skip3
	load_bg_pal bg_pal_orange
@skip3:
	rts

; update the notes palette
update_notes_pal:
	lda notes_pal
	and #3
	cmp #0
	bne @skip0
	load_fg_pal notes_pal_0
	rts
@skip0:
	cmp #1
	bne @skip1
	load_fg_pal notes_pal_1
	rts
@skip1:
	cmp #2
	bne @skip2
	load_fg_pal notes_pal_2
@skip2:
	rts

; in game logic
in_game:
	disable_ppu
	jsr update_notes_pal
	jsr update_level_pal
	inc notes_pal
	set_scroll #0, #0
	enable_ppu
	rti




;; INTERRUPTS ;;

; vsync
nmi:
	; grab the current mode and jump to the appropriate handler
	lda engine_mode
	jmp jump_mode

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

	; start the game in the title screen
	enter_title_screen
	
; do nothing forever
@forever:
	jmp @forever




;; ASSETS ;;

; palettes
bg_pal_00:	.incbin "bg.pal"
bg_pal_gold:	.incbin "gold.pal"
bg_pal_pink:	.incbin "pink.pal"
bg_pal_orange:	.incbin "orange.pal"
bg_pal_blue:	.incbin "blue.pal"
notes_pal_0:	.incbin "notes1.pal"
notes_pal_1:	.incbin "notes2.pal"
notes_pal_2:	.incbin "notes3.pal"

; nametables
nt_00:	.incbin "test1.nam"
nt_01:	.incbin "test2.nam"
nt_02:	.incbin "level.nam"
