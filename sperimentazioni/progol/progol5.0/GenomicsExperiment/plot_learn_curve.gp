# gnuplot input file that produces Encapsulated postscript
# to standard output
# to save:  gnuplot file.in > file.eps

set term postscript portrait "Times-Roman" 10
set size 0.75, 0.35

set data style lines
set nokey

set title "Theory Recovery using 68 examples"
set xlabel "Remaining codes/2 facts (%)"
set ylabel "Predictive accuracy (%)"
set xrange [0:100]
set yrange [50:100]
######### FOR 23 USE    set label 1 "After" at 20,80 left
######### FOR 45 USE    set label 1 "After" at 20,90 left
set label 1 "After" at 20,93 left
######### FOR 91 USE    set label 1 "After" at 20,92 left
set label 2 "Before" at 15,65 left

plot \
'result_train_68_exs.gp' using 2:3, \
'result_train_68_exs.gp' using 2:3:4 with errorbars,\
'result_train_68_exs.gp' using 2:5, \
'result_train_68_exs.gp' using 2:5:6 with errorbars

show label

