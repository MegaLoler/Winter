; represents a level
.struct Level
	bg		.word
	fg		.word
	map		.word
	entities	.word
.endstruct

; represents an in-game entity
.struct Entity
	identity	.byte
	state		.byte
	life_timer	.word
	x_pos		.word
	y_pos		.word
.endstruct

; an oam entry
.struct Sprite
	y_off		.byte
	char		.byte
	attr		.byte
	x_off		.byte
.endstruct

; represents a sprite consisting of multiple hardware sprites
.struct MetaSprite
	size		.byte		; number of sprites
	sprites		.tag Sprite	; array of sprites
.endstruct

; represents a frame of animation
.struct Frame
	sprite		.byte		; metasprite id	
	x_off		.byte		; x offset
	y_off		.byte		; y offset
.endstruct

; represents an animated sprite
.struct Animation
	length		.byte		; number of animation frames
	frames		.tag Frame	; array of animation frames
.endstruct
