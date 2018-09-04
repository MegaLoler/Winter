winter.nes: winter.o
	ld65 -C nes.cfg -o winter.nes winter.o

winter.o: winter.asm *.chr *.pal *.nam
	ca65 winter.asm
