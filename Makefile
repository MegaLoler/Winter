build/winter.nes: build/winter.o
	ld65 -C cfg/nes.cfg -o build/winter.nes build/winter.o

build/winter.o: src/winter.asm inc/* cfg/* bin/* chr/* pal/* nam/* map/*
	ca65 -o build/winter.o \
		-I inc \
		--bin-include-dir bin \
		--bin-include-dir chr \
		--bin-include-dir pal \
		--bin-include-dir nam \
		--bin-include-dir map \
		src/winter.asm

clean:
	rm build/*
