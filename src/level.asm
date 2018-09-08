; setup the level screen
enter_level:
	; disable ppu
	lda #$00
	sta ppuctrl
	sta ppumask

	; set the engine state
	lda #$01
	sta state

	; load the title screen nametable
	st16 tmp0, nt::test
	jsr load_nametable

	; load the color palettes
	st16 tmp0, pal::fg::main
	jsr load_fg_palette
	st16 tmp0, pal::bg::pink
	jsr load_bg_palette

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

; handler for the level screen
level_handler:
	; await the start button
	lda pad_press
	and #%00010000
	beq :+
	
	; return to the title screen
	jsr enter_title
:
	rti

