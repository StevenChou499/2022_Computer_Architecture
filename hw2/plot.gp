set title "Compare CSR cycle"
set xlabel "n^{th} Characters"
set ylabel "cycles"
set terminal png font " Times_New_Roman,12 "
set output "Compare_optimization.png"
set xtics 0 ,100, 1000
set grid
set key left 

plot "output0" using 1 with linespoints linewidth 2 title "No optimization", \
"output1" using 1 with linespoints linewidth 2 title "Optimized with SWAR", \
"output2" using 1 with linespoints linewidth 2 title "SWAR + 2 Registers", \
"output3" using 1 with linespoints linewidth 2 title "SWAR + 4 Registers", \