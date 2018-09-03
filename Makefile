winter.nes: winter.o
	ld65 -t nes -o winter.nes winter.o

winter.o: winter.asm
	ca65 winter.asm
