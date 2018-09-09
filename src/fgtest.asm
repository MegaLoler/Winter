; enter the foreground (sprite) testing screen
enter_fgtest:
	; disable ppu
	lda #$00
	sta ppuctrl
	sta ppumask

	; set the engine state
	lda #$02
	sta state

	; load the test background nametable for this screen
	st16 tmp0, nt::test2
	jsr load_nametable

	; load the sprite palette
	st16 tmp0, pal::fg::alt
	jsr load_fg_palette

	; load the bg palette
	st16 tmp0, pal::bg::pink
	jsr load_bg_palette

	; load the entity table
	st16 tmp0, ent::test
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
	lda #$1a	; show sprites and bg
	sta ppumask
	rts

; handler for the fg test screen
fgtest_handler:
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
	
	; enter the test level
	st16 tmp3, lvl::test
	jsr enter_level
:
	rti

