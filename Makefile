ASSEMBLER=ca65
LINKER=ld65
LINKER_ARGS=-C cfg/nes.cfg
DEPS=inc/* cfg/* bin/* chr/* pal/* nam/* map/*
OBJ=build/winter.o
TARGET=build/winter.nes
BUILD_DIR=build

build/%.o: src/%.asm $(DEPS)
	$(ASSEMBLER) -o $@ \
		-I inc \
		--bin-include-dir bin \
		--bin-include-dir chr \
		--bin-include-dir pal \
		--bin-include-dir nam \
		--bin-include-dir map \
		$<

$(TARGET): $(OBJ)
	$(LINKER) $(LINKER_ARGS) -o $@ $^

.PHONY: clean

clean:
	rm build/*
