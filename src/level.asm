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
	jmp :++
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
:
	cpy tmp2
	bne :--
	
	rts

; assemble oam from entity data
; as well as updating the game state
iterate_entities:
	ldy #$00	; entity pointer
	ldx #$00	; oam pointer
@entity_loop:
	tya
	pha
	txa
	pha

	; get the entity's x position
	lda entities+Entity::x_pos, y
	and #$f0
	sta tmp4
	lda entities+Entity::x_pos+1, y
	and #$0f
	clc
	adc tmp4
	ror
	ror
	ror
	ror
	ror
	sta tmp4

	; get the entity's y position
	lda entities+Entity::y_pos, y
	and #$f0
	sta tmp4+1
	lda entities+Entity::y_pos+1, y
	and #$0f
	clc
	adc tmp4+1
	ror
	ror
	ror
	ror
	ror
	sta tmp4+1

	; lookup animation set for this entity
	lda entities+Entity::identity, y
	asl
	tax
	lda anim::table, x
	sta tmp0
	lda anim::table+1, x
	sta tmp0+1

	; lookup the animation in the set for the entity's current state
	lda entities+Entity::state, y
	asl
	tay
	lda (tmp0), y
	sta tmp1
	iny
	lda (tmp0), y
	sta tmp1+1

	; get how many frames there are
	ldy #$00	; frame pointer
	lda (tmp1), y	; get frame count
	sta tmp2
	iny

	; figure out which frame to draw
	; TODO: use local timer instead of global timer
	; TODO: animation speed byte
	lda global_timer
	lsr
	lsr
	; modulo
	; modulo seems slow af, probably shouldn't do it this way or somethin?
:
	sec
	sbc tmp2
	bcs :-
	clc
	adc tmp2
	tax
	; point to that frame
:
	beq :+
	iny
	iny
	iny
	dex
	jmp :-
:		

	; draw that frame
	pla
	tax
	lda (tmp1), y
	pha
	iny
	lda (tmp1), y
	clc
	adc tmp4
	sta tmp4
	iny
	lda (tmp1), y
	clc
	adc tmp4+1
	sta tmp4+1
	pla
	jsr draw_metasprite

	; loop
	pla
	tay
	iny
	iny
	iny
	iny
	iny
	iny
	iny
	iny
	beq :+
	jmp @entity_loop
:

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
	jsr iterate_entities

	; await the start button
	lda pad_press
	and #%00010000
	beq :+
	
	; return to the title screen
	jsr enter_title
:
	rti

