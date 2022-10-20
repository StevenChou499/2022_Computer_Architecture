riscv-none-elf-gcc -R -march=rv32i -mabi=ilp32 -O0 -o lengthoflastwordO0.elf lengthoflastword.c
riscv-none-elf-objdump -D lengthoflastwordO0.elf > disassO0
riscv-none-elf-gcc -R -march=rv32i -mabi=ilp32 -O1 -o lengthoflastwordO1.elf lengthoflastword.c
riscv-none-elf-objdump -D lengthoflastwordO1.elf > disassO1
riscv-none-elf-gcc -R -march=rv32i -mabi=ilp32 -O2 -o lengthoflastwordO2.elf lengthoflastword.c
riscv-none-elf-objdump -D lengthoflastwordO2.elf > disassO2
riscv-none-elf-gcc -R -march=rv32i -mabi=ilp32 -O3 -o lengthoflastwordO3.elf lengthoflastword.c
riscv-none-elf-objdump -D lengthoflastwordO3.elf > disassO3
riscv-none-elf-gcc -R -march=rv32i -mabi=ilp32 -Os -o lengthoflastwordOs.elf lengthoflastword.c
riscv-none-elf-objdump -D lengthoflastwordOs.elf > disassOs
riscv-none-elf-gcc -R -march=rv32i -mabi=ilp32 -Ofast -o lengthoflastwordOfast.elf lengthoflastword.c
riscv-none-elf-objdump -D lengthoflastwordOfast.elf > disassOfast