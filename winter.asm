.segment "STARTUP" ; avoids warning
.segment "HEADER"
    .byte "NES", 26, 2, 1 ; 32K PRG, 8K CHR
.segment "CHARS"
    .incbin "bg.chr"
    .incbin "sprites.chr"
.segment "VECTORS"
    .word nmi, reset, irq




; GLOBAL VARS
oam = $200

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



;; WARNING: very bad code lol

.segment "CODE"

;; UTILITY MACROS ;;

.macro load_level addr
	lda #.lobyte(addr)
	sta nt_addr
	lda #.hibyte(addr)
	sta nt_addr+1
	load_bg addr
.endmacro

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
	lda #$18	; enable bg+sprites
	sta $2001
	lda #$88	; enable nmi+sprite second chr page
	sta $2000
.endmacro

.macro	disable_ppu
	lda #$00
	sta $2000	; disable nmi
	sta $2001	; disable rendering
.endmacro
	
.macro	clear_ram
	lda #0
:
	sta $000, x
	sta $100, x
	sta $300, x
	sta $400, x
	sta $500, x
	sta $600, x
	sta $700, x
	inx
	bne :-
.endmacro

.macro clear_entities
	lda #0
:
	sta entities, x
	inx
	bne :-
.endmacro


.macro clear_oam
	lda #$ff
:
	sta $200, x
	inx
	bne :-
.endmacro

.macro oam_dma
	lda #$02
	sta $4014
.endmacro

.macro	set_game_state state
	lda state
	sta engine_mode
.endmacro

.macro	set_level_pal pal
	lda pal
	sta level_pal
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

; this macro spawns an entity into the entity table at X
.macro	spawn type, state, x_pos, y_pos, x_vel, y_vel
	; write this entity's data
	lda type
	sta entities+0, x
	lda state
	sta entities+1, x
	lda x_pos
	sta entities+2, x
	lda y_pos
	sta entities+3, x
	lda x_vel
	sta entities+4, x
	lda y_vel
	sta entities+5, x
	lda #0
	sta entities+6, x
	sta entities+7, x
	txa
	clc
	adc #$8
	tax
.endmacro

;; idk why im usin macros all over the place lol
;; definitely not pretty code imo ;)
read_pad:
	; clear the pad var
	lda #0
	sta pad

	; parrently gotta write these heres to latch the buttons on a shift register ? ?
	lda #$01
	sta $4016
	lda #$00
	sta $4016

	; now read one button at a time bruh
	lda $4016	; A
	and #%00000001
	ora pad
	sta pad
	lda $4016	; B
	rol
	and #%00000010
	ora pad
	sta pad
	lda $4016	; select
	rol
	rol
	and #%00000100
	ora pad
	sta pad
	lda $4016	; start
	rol
	rol
	rol
	and #%00001000
	ora pad
	sta pad
	lda $4016	; up
	rol
	rol
	rol
	rol
	and #%00010000
	ora pad
	sta pad
	lda $4016	; down
	rol
	rol
	rol
	rol
	rol
	and #%00100000
	ora pad
	sta pad
	lda $4016	; left
	rol
	rol
	rol
	rol
	rol
	rol
	and #%01000000
	ora pad
	sta pad
	lda $4016	; right
	rol
	rol
	rol
	rol
	rol
	rol
	rol
	and #%10000000
	ora pad
	sta pad

	; get outttt ;D
	rts

.macro	get_a
	lda pad
	and #%00000001
.endmacro
.macro	get_b
	lda pad
	and #%00000010
.endmacro
.macro	get_select
	lda pad
	and #%00000100
.endmacro
.macro	get_start
	lda pad
	and #%00001000
.endmacro
.macro	get_up
	lda pad
	and #%00010000
.endmacro
.macro	get_down
	lda pad
	and #%00100000
.endmacro
.macro	get_left
	lda pad
	and #%01000000
.endmacro
.macro	get_right
	lda pad
	and #%10000000
.endmacro



;; ENGINE MODES ;;

; entering the title screen will init the whole system as well...basicaly
.macro enter_title_screen
	disable_ppu
	vblank_wait
	clear_ram
	clear_oam
	; TODO: init apu
	set_game_state #0
	vblank_wait
	oam_dma
	load_bg_pal bg_pal_00
	load_bg nt_00
	enable_ppu
.endmacro

.macro enter_game
	disable_ppu
	vblank_wait
	set_game_state #1
	set_level_pal #2
	load_fg_pal sprites_pal
	load_bg_pal bg_pal_gold
	load_level nt_02
	clear_entities

	; first find the end of the entity table
	ldx 0
	spawn #7, #0, #$48, #$30, #$00, #$00
	spawn #1, #0, #$30, #$30, #$00, #$00
	spawn #2, #0, #$40, #$30, #$01, #$00
	spawn #3, #0, #$42, #$40, #$00, #$01
	spawn #4, #0, #$30, #$50, #$00, #$00
	spawn #5, #0, #$40, #$50, #$FF, #$00
	spawn #6, #0, #$42, #$60, #$00, #$FE

	vblank_wait
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
	jsr read_pad
	get_start
	bne @niets
	rti
@niets:
	enter_game
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

.macro	draw_eighth pal
	lda entities+3, x		; get entity y position
	sta oam+0, y			; store y position
	clc
	adc #$8				; offset second sprite
	sta oam+4, y			; store y position

	lda entities+7, x		; tile number based on life timer
	and #$c
	rol
	rol
	rol
	clc
	adc #$02			; initial tile number
	sta oam+1, y			; store tile number
	clc
	adc #$10			; second tile number
	sta oam+5, y			; store tile number

	lda pal				; palette index
	sta oam+2, y			; store palette index
	sta oam+6, y			; store palette index

	lda entities+2, x		; get entity x position
	sta oam+3, y			; store x position
	sta oam+7, y			; store x position

	; increment y by how many bytes of oam were used
	tya
	clc
	adc #$8
	tay
.endmacro

.macro	draw_pair pal
	lda entities+3, x		; get entity y position
	sta oam+0, y			; store y position
	sta oam+4, y			; store y position
	clc
	adc #$8				; offset second sprite
	sta oam+8, y			; store y position
	sta oam+12, y			; store y position

	lda entities+7, x		; tile number based on life timer
	and #$c
	rol
	rol
	rol
	clc
	adc #$03			; initial tile number
	sta oam+1, y			; store tile number
	clc
	adc #$01			; second tile number
	sta oam+5, y			; store tile number
	clc
	adc #$0f			; second tile number
	sta oam+9, y			; store tile number
	clc
	adc #$01			; second tile number
	sta oam+13, y			; store tile number

	lda pal				; palette index
	sta oam+2, y			; store palette index
	sta oam+6, y			; store palette index
	sta oam+10, y			; store palette index
	sta oam+14, y			; store palette index

	lda entities+2, x		; get entity x position
	sta oam+3, y			; store x position
	sta oam+11, y			; store x position
	clc
	adc #$8				; offset second sprite
	sta oam+7, y			; store x position
	sta oam+15, y			; store x position

	; increment y by how many bytes of oam were used
	tya
	clc
	adc #$10
	tay
.endmacro

; handles collisions too..........
.macro	draw_player
	; draw stuff
	lda entities+3, x		; get entity y position
	sta y_pos			; update the mirror
	sta oam+0, y			; store y position
	sta oam+4, y			; store y position
	clc
	adc #$8				; offset second sprite
	sta oam+8, y			; store y position
	sta oam+12, y			; store y position

	lda entities+7, x		; tile number based on life timer
	and #$10
	ror
	ror
	ror
	clc
	adc #$05			; initial tile number
	sta oam+1, y			; store tile number
	clc
	adc #$01			; second tile number
	sta oam+5, y			; store tile number
	clc
	adc #$0f			; second tile number
	sta oam+9, y			; store tile number
	clc
	adc #$01			; second tile number
	sta oam+13, y			; store tile number

	lda #0				; palette index
	sta oam+2, y			; store palette index
	sta oam+6, y			; store palette index
	sta oam+10, y			; store palette index
	sta oam+14, y			; store palette index

	lda entities+2, x		; get entity x position
	sta x_pos			; update the mirror
	sta oam+3, y			; store x position
	sta oam+11, y			; store x position
	clc
	adc #$8				; offset second sprite
	sta oam+7, y			; store x position
	sta oam+15, y			; store x position

	; collisions
	; check tile beneath player
	; save regs
	txa
	pha
	tya
	pha

	; get the tile beneath the player...
	; get y pos and divide by 8 to get tile y coordinate
	lda y_pos
	clc
	adc #$10		; 16 pixel height offset
	ror
	ror
	ror
	and #$1f
	tay
	; get x pos and divide by 8 to get tile x coordinate
	lda x_pos
	ror
	ror
	ror
	and #$1f
	sta tmp
	; now x = X tile pos, and y = Y tile pos
	; now get low bytes of tile index on X
	tya
	rol
	rol
	rol
	rol
	rol
	and #$f8
	clc
	adc tmp
	tax
	; now get the high bytes on Y
	tya
	ror
	ror
	ror
	and #$1f
	tay

	; add the base of the nametable in prg to the address
	txa
	clc
	adc nt_addr
	sta tmp_addr
	tya
	adc nt_addr+1
	sta tmp_addr+1
	; now the tile address is in tmp_addr
	
	; fetch from ppu
	;lda $2002		; reset address latch
	;tya
	;sta $2006
	;txa
	;sta $2006
	;lda $2007		; the tile
	
	ldy #0
	lda (tmp_addr),y
	sta tile_under		; save it ; )

	; restore regs
	pla
	tay
	pla
	tax

	; grab the handy dandy tile beneath us already provided...
	lda tile_under
	jsr lookup_tile
	cmp #$01
	bne @no_collide
	lda #0
	sta entities+5, x	; stop that silly goose
	lda entities+3, x	; now gonna round off that y pos
	and #$f8
	sta entities+3, x
	jmp @skip_grav
@no_collide:

	; gravity......
	lda entities+7, x		; divide all acceleration
	and #7
	cmp #0
	bne @skip_accel
	lda entities+5, x		; get entity y velocity
	clc
	adc #1				; gravity ?!?!?
	cmp #$04			; max speed
	beq @skip_grav
	sta entities+5, x
@skip_grav:

	; controls...
	get_left
	beq @skip_left
	dec entities+4, x
@skip_left:
	get_right
	beq @skip_right
	inc entities+4, x
@skip_right:
	get_up
	beq @skip_up
	dec entities+5, x
@skip_up:
	get_down
	beq @skip_down
	inc entities+5, x
@skip_down:
@skip_accel:

	; increment y by how many bytes of oam were used
	tya
	clc
	adc #$10
	tay
.endmacro

lookup_tile:
	sta tmp
	txa
	pha
	ldx tmp
	lda tile_attrib, x
	sta tmp	
	pla
	tax
	lda tmp
	rts

.macro draw_do
	draw_eighth #$3
.endmacro

.macro	draw_re
	draw_eighth #$1
.endmacro

.macro	draw_mi
	draw_eighth #$0
.endmacro

.macro draw_fa
	draw_pair #$3
.endmacro

.macro	draw_sol
	draw_pair #$1
.endmacro

.macro	draw_la
	draw_pair #$0
.endmacro

; draw an entity from the entities table into oam
; X = entity location
; Y = oam location
draw_entity:
	lda entities+0, x		; get entity type
	cmp #1
	bne @skip3
	draw_do
	rts
@skip3:
	cmp #2
	bne @skip4
	draw_re
	rts
@skip4:
	cmp #3
	bne @skip5
	draw_mi
	rts
@skip5:
	cmp #4
	bne @skip6
	draw_fa
	rts
@skip6:
	cmp #5
	bne @skip7
	draw_sol
	rts
@skip7:
	cmp #6
	bne @skip8
	draw_la
	rts
@skip8:
	cmp #7
	beq @skip9
	rts
@skip9:
	draw_player
	rts

.macro	iterate_entities
	; compile the oam from the entities table
	clear_oam

	; draw all the 32 entities in the table
	ldx #$00		; entity pointer
	ldy #$00		; oam destination
@loop:
	; draw it
	jsr draw_entity

	; update positions by velocities
	lda entities+2, x		; get x velocity
	clc
	adc entities+4, x		; update x position
	sta entities+2, x
	lda entities+3, x		; get y velocity
	clc
	adc entities+5, x		; update y position
	sta entities+3, x

	; increment entity life timer
	lda #1
	clc
	adc entities+7, x
	sta entities+7, x
	lda #0
	adc entities+6, x
	sta entities+6, x

	; next entity...
	txa
	clc
	adc #$8
	tax

	; full circle?
	cmp #0
	bne @loop
.endmacro


; in game logic
in_game:
	; picture stuff
	disable_ppu
	load_fg_pal sprites_pal
	jsr update_level_pal
	set_scroll #0, #0
	oam_dma
	enable_ppu

	; prepare for next frame (less timing critical stuff)
	jsr read_pad
	iterate_entities

	; done foole
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
sprites_pal:	.incbin "sprites.pal"

; nametables
nt_00:	.incbin "test1.nam"
nt_01:	.incbin "test2.nam"
nt_02:	.incbin "level.nam"

; tile attributes
tile_attrib:	.incbin "attrib.bin"
