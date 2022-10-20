cd $HOME/riscv-none-elf-gcc
echo "export PATH=`pwd`/bin:$PATH" > setenv
cd $HOME
source riscv-none-elf-gcc/setenv
cd 2022_Computer_Architecture