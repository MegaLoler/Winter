.struct Level
	bg		.word
	fg		.word
	map		.word
	entities	.word
.endstruct

.struct Entity
	identity	.byte
	state		.byte
	life_timer	.word
	x_pos		.word
	y_pos		.word
.endstruct

; an oam entry
.struct Sprite
	y_pos		.byte
	char		.byte
	attr		.byte
	x_pos		.byte
.endstruct

.struct MetaSprite
	size		.byte		; number of sprites
	sprites		.tag Sprite	; array of sprites
.endstruct
