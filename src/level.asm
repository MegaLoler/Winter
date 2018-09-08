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
	lda #$88
	sta ppuctrl
	lda #$18	; show sprites and bg
	sta ppumask
	rts

; draw a metasprite
; x = metasprite index
; y = oam pointer
; tmp2 = x pos
; tmp3 = y pos
draw_metasprite:
	; get the pointer to the metasprite data from the table
	txa
	asl
	tax
	lda metasprites::table, x
	sta tmp0
	lda metasprites::table+1, x
	sta tmp0+1
	lda (tmp0)	; get sprite count
	asl		; x4
	asl
	sta tmp1
	; now point to base of sprite array
	inc tmp0
	bne :+
	inc tmp0+1
:
	; now copy sprites to oam
	ldx #$00
:
	lda tmp0, x	; y pos
	clc
	adc tmp3	; add the provided offset
	sta oam, y
	iny
	inx
	lda tmp0, x	; char index
	sta oam, y
	iny
	inx
	lda tmp0, x	; attributes
	sta oam, y
	iny
	inx
	lda tmp0, x	; x pos
	clc
	adc tmp2	; add the provided offset
	sta oam, y
	iny
	inx
	cpx tmp1
	bne :-
	rts

; assembly oam from entity data
draw_entities:
	ldx #$01
	ldy #$00
	lda #$40
	sta tmp2
	sta tmp3
	jsr draw_metasprite
	rts

; handler for the level screen
level_handler:
	; update oam
	jsr clear_oam
	jsr draw_entities
	lda .hibyte(oam)
	sta oamdma

	; await the start button
	lda pad_press
	and #%00010000
	beq :+
	
	; return to the title screen
	jsr enter_title
:
	rti

