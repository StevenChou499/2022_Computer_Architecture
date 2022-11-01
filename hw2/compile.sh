rm -f lengthoflastword_op0.elf lengthoflastword_op1.elf \
    lengthoflastword_op2.elf lengthoflastword_op3.elf

riscv-none-elf-as -R -march=rv32i -mabi=ilp32 -o \
    lengthoflastword_op0.o lengthoflastword_op0.S
riscv-none-elf-as -R -march=rv32i -mabi=ilp32 -o \
    lengthoflastword_op1.o lengthoflastword_op1.S
riscv-none-elf-as -R -march=rv32i -mabi=ilp32 -o \
    lengthoflastword_op2.o lengthoflastword_op2.S
riscv-none-elf-as -R -march=rv32i -mabi=ilp32 -o \
    lengthoflastword_op3.o lengthoflastword_op3.S

riscv-none-elf-ld -o lengthoflastword_op0.elf -T \
    lengthoflastword.ld --oformat=elf32-littleriscv \
    lengthoflastword_op0.o

riscv-none-elf-ld -o lengthoflastword_op1.elf -T \
    lengthoflastword.ld --oformat=elf32-littleriscv \
    lengthoflastword_op1.o

riscv-none-elf-ld -o lengthoflastword_op2.elf -T \
    lengthoflastword.ld --oformat=elf32-littleriscv \
    lengthoflastword_op2.o

riscv-none-elf-ld -o lengthoflastword_op3.elf -T \
    lengthoflastword.ld --oformat=elf32-littleriscv \
    lengthoflastword_op3.o

riscv-none-elf-size lengthoflastword_op0.elf
../rv32emu/build/rv32emu --stats lengthoflastword_op0.elf

echo -e

riscv-none-elf-size lengthoflastword_op1.elf
../rv32emu/build/rv32emu --stats lengthoflastword_op1.elf

echo -e

riscv-none-elf-size lengthoflastword_op2.elf
../rv32emu/build/rv32emu --stats lengthoflastword_op2.elf

echo -e

riscv-none-elf-size lengthoflastword_op3.elf
../rv32emu/build/rv32emu --stats lengthoflastword_op3.elf