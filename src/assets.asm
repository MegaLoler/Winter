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
		.word pal::bg::pink
		.word pal::fg::main
		.word map::test
		.word ent::test
.endscope

; metasprites
.scope metasprites
	null:
		.byte $00
	note000:
		.byte $02
		.byte $00, $a0, $00, $00
		.byte $08, $b0, $00, $00
	note001:
		.byte $02
		.byte $00, $c0, $00, $00
		.byte $08, $d0, $00, $00
	note002:
		.byte $02
		.byte $00, $e0, $00, $00
		.byte $08, $f0, $00, $00
	note010:
		.byte $02
		.byte $00, $a0, $01, $00
		.byte $08, $b0, $01, $00
	note011:
		.byte $02
		.byte $00, $c0, $01, $00
		.byte $08, $d0, $01, $00
	note012:
		.byte $02
		.byte $00, $e0, $01, $00
		.byte $08, $f0, $01, $00
	note020:
		.byte $02
		.byte $00, $a0, $02, $00
		.byte $08, $b0, $02, $00
	note021:
		.byte $02
		.byte $00, $c0, $02, $00
		.byte $08, $d0, $02, $00
	note022:
		.byte $02
		.byte $00, $e0, $02, $00
		.byte $08, $f0, $02, $00
	note030:
		.byte $02
		.byte $00, $a0, $03, $00
		.byte $08, $b0, $03, $00
	note031:
		.byte $02
		.byte $00, $c0, $03, $00
		.byte $08, $d0, $03, $00
	note032:
		.byte $02
		.byte $00, $e0, $03, $00
		.byte $08, $f0, $03, $00
	note100:
		.byte $04
		.byte $00, $a1, $00, $00
		.byte $00, $a2, $00, $08
		.byte $08, $b1, $00, $00
		.byte $08, $b2, $00, $08
	note101:
		.byte $04
		.byte $00, $c1, $00, $00
		.byte $00, $c2, $00, $08
		.byte $08, $d1, $00, $00
		.byte $08, $d2, $00, $08
	note102:
		.byte $04
		.byte $00, $e1, $00, $00
		.byte $00, $e2, $00, $08
		.byte $08, $f1, $00, $00
		.byte $08, $f2, $00, $08
	note110:
		.byte $04
		.byte $00, $a1, $01, $00
		.byte $00, $a2, $01, $08
		.byte $08, $b1, $01, $00
		.byte $08, $b2, $01, $08
	note111:
		.byte $04
		.byte $00, $c1, $01, $00
		.byte $00, $c2, $01, $08
		.byte $08, $d1, $01, $00
		.byte $08, $d2, $01, $08
	note112:
		.byte $04
		.byte $00, $e1, $01, $00
		.byte $00, $e2, $01, $08
		.byte $08, $f1, $01, $00
		.byte $08, $f2, $01, $08
	note120:
		.byte $04
		.byte $00, $a1, $02, $00
		.byte $00, $a2, $02, $08
		.byte $08, $b1, $02, $00
		.byte $08, $b2, $02, $08
	note121:
		.byte $04
		.byte $00, $c1, $02, $00
		.byte $00, $c2, $02, $08
		.byte $08, $d1, $02, $00
		.byte $08, $d2, $02, $08
	note122:
		.byte $04
		.byte $00, $e1, $02, $00
		.byte $00, $e2, $02, $08
		.byte $08, $f1, $02, $00
		.byte $08, $f2, $02, $08
	note130:
		.byte $04
		.byte $00, $a1, $03, $00
		.byte $00, $a2, $03, $08
		.byte $08, $b1, $03, $00
		.byte $08, $b2, $03, $08
	note131:
		.byte $04
		.byte $00, $c1, $03, $00
		.byte $00, $c2, $03, $08
		.byte $08, $d1, $03, $00
		.byte $08, $d2, $03, $08
	note132:
		.byte $04
		.byte $00, $e1, $03, $00
		.byte $00, $e2, $03, $08
		.byte $08, $f1, $03, $00
		.byte $08, $f2, $03, $08

	; lookup table of all the metasprites
	table:
		.word null
		.word note000, note001, note002
		.word note010, note011, note012
		.word note020, note021, note022
		.word note030, note031, note032
		.word note100, note101, note102
		.word note110, note111, note112
		.word note120, note121, note122
		.word note130, note131, note132
.endscope

; animation sets
.scope anim
	.scope null
		null:
			.byte $01, $00
			.byte $00, $00, $00
		table:	.word null
	.endscope
	.scope note
		float0:
			.byte $08, $01
			.byte $00, $00, $02	
			.byte $01, $00, $01	
			.byte $02, $00, $ff	
			.byte $03, $00, $fe	
			.byte $00, $00, $fe	
			.byte $01, $00, $ff	
			.byte $02, $00, $01	
			.byte $03, $00, $02	
		float1:
			.byte $08, $02
			.byte $00, $00, $02	
			.byte $04, $00, $01	
			.byte $05, $00, $ff	
			.byte $06, $00, $fe	
			.byte $00, $00, $fe	
			.byte $04, $00, $ff	
			.byte $05, $00, $01	
			.byte $06, $00, $02	
		float2:
			.byte $08, $03
			.byte $00, $00, $02	
			.byte $07, $00, $01	
			.byte $08, $00, $ff	
			.byte $09, $00, $fe	
			.byte $00, $00, $fe	
			.byte $07, $00, $ff	
			.byte $08, $00, $01	
			.byte $09, $00, $02	
		float3:
			.byte $08, $04
			.byte $00, $00, $02	
			.byte $0a, $00, $01	
			.byte $0b, $00, $ff	
			.byte $0c, $00, $fe	
			.byte $00, $00, $fe	
			.byte $0a, $00, $ff	
			.byte $0b, $00, $01	
			.byte $0c, $00, $02	

		; table of all the animations for this entity
		table:
			.word float0, float1, float2, float3
	.endscope
	.scope doublenote
		float0:
			.byte $08, $04
			.byte $00, $00, $02	
			.byte $0d, $00, $01	
			.byte $0e, $00, $ff	
			.byte $0f, $00, $fe	
			.byte $00, $00, $fe	
			.byte $0d, $00, $ff	
			.byte $0e, $00, $01	
			.byte $0f, $00, $02	
		float1:
			.byte $08, $03
			.byte $00, $00, $02	
			.byte $10, $00, $01	
			.byte $11, $00, $ff	
			.byte $12, $00, $fe	
			.byte $00, $00, $fe	
			.byte $10, $00, $ff	
			.byte $11, $00, $01	
			.byte $12, $00, $02	
		float2:
			.byte $08, $02
			.byte $00, $00, $02	
			.byte $13, $00, $01	
			.byte $14, $00, $ff	
			.byte $15, $00, $fe	
			.byte $00, $00, $fe	
			.byte $13, $00, $ff	
			.byte $14, $00, $01	
			.byte $15, $00, $02	
		float3:
			.byte $08, $01
			.byte $00, $00, $02	
			.byte $16, $00, $01	
			.byte $17, $00, $ff	
			.byte $18, $00, $fe	
			.byte $00, $00, $fe	
			.byte $16, $00, $ff	
			.byte $17, $00, $01	
			.byte $18, $00, $02	

		; table of all the animations for this entity
		table:
			.word float0, float1, float2, float3
	.endscope

	; lookup table of all the animation sets
	table:
		.word null::table, note::table, doublenote::table
.endscope
