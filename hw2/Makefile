.PHONY: clean

include ../rv32emu/mk/toolchain.mk

ASFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS = --oformat=elf32-littleriscv

%.o: %.S
	$(CROSS_COMPILE)as -R $(ASFLAGS) -o $@ $<

normal: lengthoflastword.elf

optimized: lengthoflastword_op0.elf

lengthoflastword.elf: lengthoflastword.o
	 $(CROSS_COMPILE)ld -o $@ -T lengthoflastword.ld $(LDFLAGS) $<

lengthoflastword_op0.elf: lengthoflastword_op0.o
	 $(CROSS_COMPILE)ld -o $@ -T lengthoflastword.ld $(LDFLAGS) $<

clean:
	$(RM) lengthoflastword.elf lengthoflastword.o
	$(RM) lengthoflastword_op0.elf lengthoflastword_op0.o
