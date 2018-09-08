; setup the level screen
; tmp3 = level address
enter_level:
	; disable ppu
	lda #$00
	sta ppuctrl
	sta ppumask

	; set the engine state
	lda #$01
	sta state

	; load the test background nametable
	st16 tmp0, nt::test
	jsr load_nametable

	; load the sprite palette
	ldy #Level::fg
	lda (tmp3), y
	sta tmp0
	iny
	lda (tmp3), y
	sta tmp0+1
	jsr load_fg_palette

	; load the bg palette
	ldy #Level::bg
	lda (tmp3), y
	sta tmp0
	iny
	lda (tmp3), y
	sta tmp0+1
	jsr load_bg_palette

	; load the map data
	ldy #Level::map
	lda (tmp3), y
	sta tmp0
	iny
	lda (tmp3), y
	sta tmp0+1
	st16 tmp1, map
	st16 tmp2, $400
	jsr copy

	; load the entity table
	ldy #Level::entities
	lda (tmp3), y
	sta tmp0
	iny
	lda (tmp3), y
	sta tmp0+1
	st16 tmp1, entities
	st16 tmp2, $100
	jsr copy

	; reset scrolling
	lda #$00
	sta ppuscroll
	sta ppuscroll

	; enable the ppu
	lda #$88	; enable nmi and use second chr page for sprites
	sta ppuctrl
	lda #$18	; show sprites and bg
	sta ppumask
	rts

; draw a metasprite
; a = metasprite index
; x = oam pointer
; tmp4 = xy pos
draw_metasprite:
	; get address of metasprite
	asl
	tay
	lda metasprites::table, y
	sta tmp0
	lda metasprites::table+1, y
	sta tmp0+1

	; get the sprite count and multiply by four
	ldy #$00
	lda (tmp0), y
	asl
	asl	
	sta tmp2

	; point to the base of the array
	inc tmp0
	bne :+
	inc tmp0+1
:

	; copy data
:
	; copy y pos
	lda (tmp0), y
	clc
	adc tmp4+1	; add y offset
	sta oam, x
	inx
	iny
	; copy char
	lda (tmp0), y
	sta oam, x
	inx
	iny
	; copy attributes
	lda (tmp0), y
	sta oam, x
	inx
	iny
	; copy x pos
	lda (tmp0), y
	clc
	adc tmp4	; add x offset
	sta oam, x
	inx
	iny
	; loop
	cpy tmp2
	bne :-	
	
	rts

; assembly oam from entity data
draw_entities:
	ldx #$00
	st16 tmp4, $4030
	lda #$01
	jsr draw_metasprite
	st16 tmp4, $3030
	lda #$02
	jsr draw_metasprite
	st16 tmp4, $2030
	lda #$03
	jsr draw_metasprite
	st16 tmp4, $1030
	lda #$04
	jsr draw_metasprite
	rts

; handler for the level screen
level_handler:
	; copy oam
	lda #.lobyte(oam)
	sta oamaddr
	lda #.hibyte(oam)
	sta oamdma

	; update oam for next frame
	jsr clear_oam
	jsr draw_entities

	; await the start button
	lda pad_press
	and #%00010000
	beq :+
	
	; return to the title screen
	jsr enter_title
:
	rti

