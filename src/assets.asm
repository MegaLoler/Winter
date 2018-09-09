.segment "CODE"

; palettes
.scope pal
	.scope bg
		title:		.incbin "title.pal"
		pink:		.incbin "pink.pal"
		blue:		.incbin "blue.pal"
	.endscope
	.scope fg
		main:		.incbin "sprites.pal"
		alt:		.incbin "sprites_sharp.pal"
	.endscope
.endscope

; nametables
.scope nt
	title:			.incbin "title.nam"
	test:			.incbin "bgtest.nam"
.endscope

; maps
.scope map
	test:			.incbin "test.map"
.endscope

; entity tables
.scope ent
	test:			.incbin "test.ent"
.endscope

; levels
.scope lvl
	test:
		.word pal::bg::blue
		.word pal::fg::main
		.word map::test
		.word ent::test
.endscope

; metasprites
.scope metasprites
	null:
		.byte $00
	note00:
		.byte $02
		.byte $00, $a0, $00, $00
		.byte $08, $b0, $00, $00
	note01:
		.byte $02
		.byte $00, $c0, $00, $00
		.byte $08, $d0, $00, $00
	note02:
		.byte $02
		.byte $00, $e0, $00, $00
		.byte $08, $f0, $00, $00
	note10:
		.byte $04
		.byte $00, $a1, $00, $00
		.byte $00, $a2, $00, $08
		.byte $08, $b1, $00, $00
		.byte $08, $b2, $00, $08
	note11:
		.byte $04
		.byte $00, $c1, $00, $00
		.byte $00, $c2, $00, $08
		.byte $08, $d1, $00, $00
		.byte $08, $d2, $00, $08
	note12:
		.byte $04
		.byte $00, $e1, $00, $00
		.byte $00, $e2, $00, $08
		.byte $08, $f1, $00, $00
		.byte $08, $f2, $00, $08

	; lookup table of all the metasprites
	table:
		.word null, note00, note01, note02, note10, note11, note12
.endscope

; animation sets
.scope anim
	.scope null
		null:
			.byte $01
			.byte $00, $00, $00
		table:	.word null
	.endscope
	.scope note
		twinkle:
			.byte $04
			.byte $00, $00, $00	
			.byte $01, $00, $00	
			.byte $02, $00, $00	
			.byte $03, $00, $00	

		float:
			.byte $08
			.byte $00, $00, $00	
			.byte $01, $00, $ff	
			.byte $02, $00, $fd	
			.byte $03, $00, $fc	
			.byte $00, $00, $fc	
			.byte $01, $00, $fd	
			.byte $02, $00, $ff	
			.byte $03, $00, $00	

		; table of all the animations for this entity
		table:
			.word twinkle, float
	.endscope
	.scope doublenote
		twinkle:
			.byte $04
			.byte $00, $00, $00	
			.byte $04, $00, $00	
			.byte $05, $00, $00	
			.byte $06, $00, $00	

		float:
			.byte $08
			.byte $00, $00, $00	
			.byte $04, $00, $ff	
			.byte $05, $00, $fd	
			.byte $06, $00, $fc	
			.byte $00, $00, $fc	
			.byte $04, $00, $fd	
			.byte $05, $00, $ff	
			.byte $06, $00, $00	

		; table of all the animations for this entity
		table:
			.word twinkle, float
	.endscope

	; lookup table of all the animation sets
	table:
		.word null::table, note::table, doublenote::table
.endscope
