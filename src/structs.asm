.struct Entity
	identity	.byte
	state		.byte
	life_timer	.word
	x_pos		.word
	y_pos		.word
.endstruct

.struct Level
	bg		.word
	fg		.word
	map		.word
	entities	.word
.endstruct
