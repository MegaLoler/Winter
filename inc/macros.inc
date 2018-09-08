; some convenience macros for ca65

; store an immediate 16-bit value as little endian
.macro st16	addr, data
	lda #.lobyte(data)
	sta addr
	lda #.hibyte(data)
	sta addr+1
.endmacro

; write an immediate 16 bit value to a single port as big endian
.macro out16	port, data
	lda #.hibyte(data)
	sta port
	lda #.lobyte(data)
	sta port
.endmacro

; latch an immediate value into the ppuaddr register
.macro ppulatch	addr
	; reset the latch
	bit ppustatus
	; store the value
	out16 ppuaddr, addr
.endmacro
