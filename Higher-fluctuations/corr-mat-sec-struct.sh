#!/bin/bash

echo "Trajectory file (e.g., traj.nc):"
read TRAJ
echo "========================"
echo "========================"

echo "Topology file (e.g., top.prmtop):"
read TOP
echo "========================"
echo "========================"

echo "Residue range (e.g., 1-120):"
read RESRANGE
echo "========================"
echo "========================"

echo "Atom mask (e.g., CA or N,CA,C,O or *):"
read ATOMMASK
echo "========================"
echo "========================"

echo "Start frame:"
read START

echo "End frame:"
read END
echo "========================"
echo "========================"

echo "Stride:"
read STRIDE
echo "========================"
echo "========================"

echo "Base name for output (e.g., my-corr):"
read BASENAME

OUTFILE="${BASENAME}.in"

cat << EOF > $OUTFILE
parm $TOP
trajin $TRAJ $START $END $STRIDE

# Correlation matrix for selected residues and atoms
matrix correl name ${BASENAME}_corr :${RESRANGE}@${ATOMMASK} out ${BASENAME}corr--matrix.dat
run

# secondary structure analysis
trajin $TRAJ $START $END $STRIDE
secstruct :${RESRANGE} out ${BASENAME}-dssp.gnu sumout ${BASENAME}-dssp.agr
run
EOF
echo "========================"
echo "========================"

echo "Cpptraj script created: $OUTFILE"
cpptraj -i $OUTFILE
