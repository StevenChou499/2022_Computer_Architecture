#!/bin/bash
rm -f output0 output1 output2 output3

sed -i '10s/.*/str1:       .string ""/' lengthoflastword_op0.S
sed -i '10s/.*/str1:       .string ""/' lengthoflastword_op1.S
sed -i '10s/.*/str1:       .string ""/' lengthoflastword_op2.S
sed -i '10s/.*/str1:       .string ""/' lengthoflastword_op3.S


for i in {1..1000..1}
do
    sed -i '10 s/"/a"/2' lengthoflastword_op0.S
    sed -i '10 s/"/a"/2' lengthoflastword_op1.S
    sed -i '10 s/"/a"/2' lengthoflastword_op2.S
    sed -i '10 s/"/a"/2' lengthoflastword_op3.S
    rm -f lengthoflastword_op0.elf lengthoflastword_op1.elf lengthoflastword_op2.elf lengthoflastword_op3.elf

    riscv-none-elf-as -R -march=rv32i -mabi=ilp32 -o lengthoflastword_op0.o lengthoflastword_op0.S
    riscv-none-elf-as -R -march=rv32i -mabi=ilp32 -o lengthoflastword_op1.o lengthoflastword_op1.S
    riscv-none-elf-as -R -march=rv32i -mabi=ilp32 -o lengthoflastword_op2.o lengthoflastword_op2.S
    riscv-none-elf-as -R -march=rv32i -mabi=ilp32 -o lengthoflastword_op3.o lengthoflastword_op3.S

    riscv-none-elf-ld -o lengthoflastword_op0.elf -T lengthoflastword.ld --oformat=elf32-littleriscv lengthoflastword_op0.o
    riscv-none-elf-ld -o lengthoflastword_op1.elf -T lengthoflastword.ld --oformat=elf32-littleriscv lengthoflastword_op1.o
    riscv-none-elf-ld -o lengthoflastword_op2.elf -T lengthoflastword.ld --oformat=elf32-littleriscv lengthoflastword_op2.o
    riscv-none-elf-ld -o lengthoflastword_op3.elf -T lengthoflastword.ld --oformat=elf32-littleriscv lengthoflastword_op3.o

    ../rv32emu/build/rv32emu --stats lengthoflastword_op0.elf >> output0
    ../rv32emu/build/rv32emu --stats lengthoflastword_op1.elf >> output1
    ../rv32emu/build/rv32emu --stats lengthoflastword_op2.elf >> output2
    ../rv32emu/build/rv32emu --stats lengthoflastword_op3.elf >> output3
done

sed '/inferior exit code 0/d' output0 > tmp0
sed 's/CSR cycle count: //g' tmp0 > output0
rm -f tmp0

sed '/inferior exit code 0/d' output1 > tmp1
sed 's/CSR cycle count: //g' tmp1 > output1
rm -f tmp1

sed '/inferior exit code 0/d' output2 > tmp2
sed 's/CSR cycle count: //g' tmp2 > output2
rm -f tmp2

sed '/inferior exit code 0/d' output3 > tmp3
sed 's/CSR cycle count: //g' tmp3 > output3
rm -f tmp3

gnuplot plot.gp