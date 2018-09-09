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
	cheese0r:
		.byte $04
		.byte $00, $00, $02, $00
		.byte $00, $01, $02, $08
		.byte $08, $10, $02, $00
		.byte $08, $11, $02, $08
	cheese1r:
		.byte $04
		.byte $00, $02, $02, $00
		.byte $00, $03, $02, $08
		.byte $08, $12, $02, $00
		.byte $08, $13, $02, $08
	cheese2r:
		.byte $04
		.byte $00, $04, $02, $00
		.byte $00, $05, $02, $08
		.byte $08, $14, $02, $00
		.byte $08, $15, $02, $08
	cheese3r:
		.byte $04
		.byte $00, $06, $02, $00
		.byte $00, $07, $02, $08
		.byte $08, $16, $02, $00
		.byte $08, $17, $02, $08
	cheese0l:
		.byte $04
		.byte $00, $01, $42, $00
		.byte $00, $00, $42, $08
		.byte $08, $11, $42, $00
		.byte $08, $10, $42, $08
	cheese1l:
		.byte $04
		.byte $00, $03, $42, $00
		.byte $00, $02, $42, $08
		.byte $08, $13, $42, $00
		.byte $08, $12, $42, $08
	cheese2l:
		.byte $04
		.byte $00, $05, $42, $00
		.byte $00, $04, $42, $08
		.byte $08, $15, $42, $00
		.byte $08, $14, $42, $08
	cheese3l:
		.byte $04
		.byte $00, $07, $42, $00
		.byte $00, $06, $42, $08
		.byte $08, $17, $42, $00
		.byte $08, $16, $42, $08
	berry0r:
		.byte $04
		.byte $00, $20, $01, $00
		.byte $00, $21, $01, $08
		.byte $08, $30, $01, $00
		.byte $08, $31, $01, $08
	berry1r:
		.byte $04
		.byte $00, $22, $01, $00
		.byte $00, $23, $01, $08
		.byte $08, $32, $01, $00
		.byte $08, $33, $01, $08
	berry2r:
		.byte $04
		.byte $00, $24, $01, $00
		.byte $00, $25, $01, $08
		.byte $08, $34, $01, $00
		.byte $08, $35, $01, $08
	berry3r:
		.byte $04
		.byte $00, $26, $01, $00
		.byte $00, $27, $01, $08
		.byte $08, $36, $01, $00
		.byte $08, $37, $01, $08
	berry0l:
		.byte $04
		.byte $00, $21, $41, $00
		.byte $00, $20, $41, $08
		.byte $08, $31, $41, $00
		.byte $08, $30, $41, $08
	berry1l:
		.byte $04
		.byte $00, $23, $41, $00
		.byte $00, $22, $41, $08
		.byte $08, $33, $41, $00
		.byte $08, $32, $41, $08
	berry2l:
		.byte $04
		.byte $00, $25, $41, $00
		.byte $00, $24, $41, $08
		.byte $08, $35, $41, $00
		.byte $08, $34, $41, $08
	berry3l:
		.byte $04
		.byte $00, $27, $41, $00
		.byte $00, $26, $41, $08
		.byte $08, $37, $41, $00
		.byte $08, $36, $41, $08
	berries0r:
		.byte $04
		.byte $00, $40, $03, $00
		.byte $00, $41, $03, $08
		.byte $08, $50, $03, $00
		.byte $08, $51, $03, $08
	berries1r:
		.byte $04
		.byte $00, $42, $03, $00
		.byte $00, $43, $03, $08
		.byte $08, $52, $03, $00
		.byte $08, $53, $03, $08
	berries2r:
		.byte $04
		.byte $00, $44, $03, $00
		.byte $00, $45, $03, $08
		.byte $08, $54, $03, $00
		.byte $08, $55, $03, $08
	berries3r:
		.byte $04
		.byte $00, $46, $03, $00
		.byte $00, $47, $03, $08
		.byte $08, $56, $03, $00
		.byte $08, $57, $03, $08
	berries0l:
		.byte $04
		.byte $00, $41, $43, $00
		.byte $00, $40, $43, $08
		.byte $08, $51, $43, $00
		.byte $08, $50, $43, $08
	berries1l:
		.byte $04
		.byte $00, $43, $43, $00
		.byte $00, $42, $43, $08
		.byte $08, $53, $43, $00
		.byte $08, $52, $43, $08
	berries2l:
		.byte $04
		.byte $00, $45, $43, $00
		.byte $00, $44, $43, $08
		.byte $08, $55, $43, $00
		.byte $08, $54, $43, $08
	berries3l:
		.byte $04
		.byte $00, $47, $43, $00
		.byte $00, $46, $43, $08
		.byte $08, $57, $43, $00
		.byte $08, $56, $43, $08

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
		.word cheese0r, cheese1r, cheese2r, cheese3r
		.word cheese0l, cheese1l, cheese2l, cheese3l
		.word berry0r, berry1r, berry2r, berry3r
		.word berry0l, berry1l, berry2l, berry3l
		.word berries0r, berries1r, berries2r, berries3r
		.word berries0l, berries1l, berries2l, berries3l
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
			.byte $08, $03
			.byte $00, $00, $02	
			.byte $01, $00, $01	
			.byte $02, $00, $ff	
			.byte $03, $00, $fe	
			.byte $00, $00, $fe	
			.byte $01, $00, $ff	
			.byte $02, $00, $01	
			.byte $03, $00, $02	
		float1:
			.byte $08, $03
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
			.byte $08, $03
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
			.byte $08, $03
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
			.byte $08, $03
			.byte $00, $00, $02	
			.byte $13, $00, $01	
			.byte $14, $00, $ff	
			.byte $15, $00, $fe	
			.byte $00, $00, $fe	
			.byte $13, $00, $ff	
			.byte $14, $00, $01	
			.byte $15, $00, $02	
		float3:
			.byte $08, $03
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
	.scope cheese
		idler:
			.byte $02, $10
			.byte $1a, $00, $00
			.byte $1b, $00, $00
		idlel:
			.byte $02, $10
			.byte $1e, $00, $00
			.byte $1f, $00, $00
		bouncer:
			.byte $08, $04
			.byte $19, $00, $00
			.byte $19, $00, $00
			.byte $1a, $00, $00
			.byte $1b, $00, $00
			.byte $1c, $00, $00
			.byte $1c, $00, $00
			.byte $1b, $00, $00
			.byte $1a, $00, $00
		bouncel:
			.byte $08, $04
			.byte $1d, $00, $00
			.byte $1d, $00, $00
			.byte $1e, $00, $00
			.byte $1f, $00, $00
			.byte $20, $00, $00
			.byte $20, $00, $00
			.byte $1f, $00, $00
			.byte $1e, $00, $00

		; table of all the animations for this entity
		table:
			.word idler, idlel
			.word bouncer, bouncel
	.endscope
	.scope berry
		idler:
			.byte $02, $10
			.byte $22, $00, $00
			.byte $23, $00, $00
		idlel:
			.byte $02, $10
			.byte $26, $00, $00
			.byte $27, $00, $00
		bouncer:
			.byte $08, $04
			.byte $21, $00, $00
			.byte $21, $00, $00
			.byte $22, $00, $00
			.byte $23, $00, $00
			.byte $24, $00, $00
			.byte $24, $00, $00
			.byte $23, $00, $00
			.byte $22, $00, $00
		bouncel:
			.byte $08, $04
			.byte $25, $00, $00
			.byte $25, $00, $00
			.byte $26, $00, $00
			.byte $27, $00, $00
			.byte $28, $00, $00
			.byte $28, $00, $00
			.byte $27, $00, $00
			.byte $26, $00, $00

		; table of all the animations for this entity
		table:
			.word idler, idlel
			.word bouncer, bouncel
	.endscope
	.scope berries
		idler:
			.byte $02, $10
			.byte $2a, $00, $00
			.byte $2b, $00, $00
		idlel:
			.byte $02, $10
			.byte $2e, $00, $00
			.byte $2f, $00, $00
		bouncer:
			.byte $08, $04
			.byte $29, $00, $00
			.byte $29, $00, $00
			.byte $2a, $00, $00
			.byte $2b, $00, $00
			.byte $2c, $00, $00
			.byte $2c, $00, $00
			.byte $2b, $00, $00
			.byte $2a, $00, $00
		bouncel:
			.byte $08, $04
			.byte $2d, $00, $00
			.byte $2d, $00, $00
			.byte $2e, $00, $00
			.byte $2f, $00, $00
			.byte $30, $00, $00
			.byte $30, $00, $00
			.byte $2f, $00, $00
			.byte $2e, $00, $00

		; table of all the animations for this entity
		table:
			.word idler, idlel
			.word bouncer, bouncel
	.endscope

	; lookup table of all the animation sets
	table:
		.word null::table
		.word note::table, doublenote::table
		.word cheese::table, berry::table, berries::table
.endscope
