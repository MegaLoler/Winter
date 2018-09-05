build/winter.nes: build/winter.o
	ld65 -C cfg/nes.cfg -o build/winter.nes build/winter.o

build/winter.o: src/winter.asm chr/* pal/* nam/* bin/*
	ca65 -o build/winter.o \
		--bin-include-dir chr \
		--bin-include-dir pal \
		--bin-include-dir nam \
		--bin-include-dir bin \
		src/winter.asm

clean:
	rm build/*
