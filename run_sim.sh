# Sample usage:
# run_sim.sh ./ Systolic_Matrix_tb lab6
# vvp -n lab6 -fst
# Then open that file with GTKWave
# gtkwave lab6.fst -o

iverilog -g2005-sv -s $2 -o $3 $(find $1 -type f \( -name "*.v" -o -name "*.sv" \))
# vvp $3 -fst
