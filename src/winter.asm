.segment "STARTUP" ; avoids warning
.segment "HEADER"
    .byte "NES", 26, 2, 1 ; 32K PRG, 8K CHR
.segment "CHARS"
    .incbin "bg.chr"
    .incbin "sprites.chr"
.segment "VECTORS"
    .word nmi, reset, irq




.segment "ZEROPAGE"
engine_mode:	.res 1		; engine state
level_pal:	.res 1		; bg palette index
tmp:		.res 1		; tmp var???
x_pos:		.res 1		; mirror of player x
y_pos:		.res 1		; mirror of player y
tile_under:	.res 1		; the tile under the player
nt_addr:	.res 2		; address of currently loaded nametable
tmp_addr:	.res 2		; tmp 16 bit var
pad:		.res 1		; place to put the buttons! ^_^

.segment "BSS"
entities:	.res $100	; entity table



.segment "CODE"
;; INTERRUPTS ;;

; vsync
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

	; start the game in the title screen
	;enter_title_screen
	
; do nothing forever
:
	jmp :-




;; ASSETS ;;

; palettes
bg_pal_title:	.incbin "title.pal"
bg_pal_pink:	.incbin "pink.pal"
bg_pal_blue:	.incbin "blue.pal"
sprites_pal:	.incbin "sprites.pal"

; nametables
nt_title:	.incbin "title.nam"
;nt_hud:	.incbin "hud.nam"

; maps

; tile attributes
tile_attrib:	.incbin "attrib.bin"
