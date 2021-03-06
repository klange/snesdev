PREFIX=../
OPTIMIZE=1

CFLAGS=-Wall
ifeq ($(OPTIMIZE),1)
CFLAGS += -O
endif

BINDIR=$(PREFIX)/bin
AS=$(BINDIR)/wla-65816
LD=$(BINDIR)/wlalink
CC=$(BINDIR)/816-tcc
#EMU=$(BINDIR)/snes9x
EMU=bsnes

LIBDIR=$(PREFIX)/lib

ASMOBJ = data.obj
COBJ = snesc.obj input.obj init.obj graph.obj str.obj
ACOBJ = arena.obj input.obj init.obj graph.obj str.obj

all: snesc.smc
#	$(EMU) snesc.smc || xset r on

snesc.smc: $(ASMOBJ) $(COBJ)
	$(LD) -dvSo $(ASMOBJ) $(COBJ) snesc.smc

arena.smc: $(ASMOBJ) $(ACOBJ)
	$(LD) -dvSo $(ASMOBJ) $(ACOBJ) arena.smc

%.s: %.c
	$(CC) $(CFLAGS) -I. -I$(PREFIX)/include -o $@ -c $<

%.obj: %.s
	$(AS) -io $< $@
%.obj: %.asm hdr.asm
	$(AS) -io $< $@

clean:
	rm -f snesc.smc snesc.sym $(ASMOBJ) $(COBJ) *.s

clean_arena:
	rm -f arena.smc arena.sym $(ASMOBJ) $(ACOBJ) *.s
