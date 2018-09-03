.segment "STARTUP" ; avoids warning
.segment "HEADER"
    .byte "NES", 26, 2, 1 ; 32K PRG, 8K CHR
.segment "CHARS"
    .incbin "winter.chr"
.segment "VECTORS"
    .word nmi, reset, irq

.segment "ZEROPAGE"

; what mode the game engine is in
engine_mode:	.res 1

.segment "CODE"
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

; ENGINE MODES
; enter title screen mode
enter_title_screen:
	rts

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

	; TODO: init ppu
	; TODO: init apu
	; TODO: clear ram

	; init vars
	; set mode to enter title screen
	lda #$00
	sta engine_mode

@loop:
	; do nothing forever
	jmp @loop
