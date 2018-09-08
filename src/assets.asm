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
	table:
		.word null, note00, note01, note02, note10, note11, note12

	null:
		.byte $0
	note00:
		.byte $2
		.byte $00, $a0, $00, $00
		.byte $08, $b0, $00, $00
	note01:
		.byte $2
		.byte $00, $c0, $00, $00
		.byte $08, $d0, $00, $00
	note02:
		.byte $2
		.byte $00, $e0, $00, $00
		.byte $08, $f0, $00, $00
	note10:
		.byte $4
		.byte $00, $a1, $00, $00
		.byte $00, $a2, $00, $08
		.byte $08, $b1, $00, $00
		.byte $08, $b2, $00, $08
	note11:
		.byte $4
		.byte $00, $c1, $00, $00
		.byte $00, $c2, $00, $08
		.byte $08, $d1, $00, $00
		.byte $08, $d2, $00, $08
	note12:
		.byte $4
		.byte $00, $e1, $00, $00
		.byte $00, $e2, $00, $08
		.byte $08, $f1, $00, $00
		.byte $08, $f2, $00, $08
.endscope

