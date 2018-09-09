; setup the bgtest screen
enter_bgtest:
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

	; load the bg palette
	st16 tmp0, pal::bg::pink
	jsr load_bg_palette

	; reset scrolling
	lda #$00
	sta ppuscroll
	sta ppuscroll

	; enable the ppu
	lda #$88	; enable nmi and use second chr page for sprites
	sta ppuctrl
	lda #$08	; show bg only
	sta ppumask
	rts

; handler for the bgtest screen
bgtest_handler:
	; await the start button
	lda pad_press
	and #%00010000
	beq :+
	
	; enter the foreground test
	jsr enter_fgtest
:
	rti

