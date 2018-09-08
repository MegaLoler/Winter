.struct Entity
	identity	.byte
	state		.byte
	life_timer	.word
	x_pos		.word
	y_pos		.word
.endstruct

.struct Level
	; dimensions of the map in metatiles
	width		.byte
	height		.byte

	; all pointers
	palette		.word
	map		.word
	entities	.word
.endstruct
