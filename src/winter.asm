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
	; width in tiles of map
	width		.byte

	; all pointers
	palette		.word
	map		.word
	entities	.word
.endstruct




.segment "ZEROPAGE"
; engine state
state:		.res 1

; scratch vars
tmp0:		.res 2
tmp1:		.res 2

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
