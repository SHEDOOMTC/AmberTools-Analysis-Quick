#!/bin/bash

echo "Trajectory file (e.g., traj.nc):"
read TRAJ
echo "========================"
echo "========================"

echo "Topology file (e.g., top.prmtop):"
read TOP
echo "========================"
echo "========================"

echo "Start frame:"
read START
echo "========================"
echo "========================"

echo "End frame:"
read END
echo "========================"
echo "========================"

echo "Interval (stride; please optimize to use a total of 500-100 frames for computational efficiency):"
read INTERVAL
echo "========================"
echo "========================"

echo "Do you want to run GB or PB? (type GB or PB):"
read METHOD
echo "========================"
echo "========================"

# Normalize to uppercase
METHOD=$(echo "$METHOD" | tr '[:lower:]' '[:upper:]')

echo "Enter the Ligand Mask (e.g. 390):"
read LIGANDMASK
echo "========================"
echo "========================"

echo "Residues for decomposition (semicolon-separated, e.g. 14;36;):"
read RESLIST
echo "========================"
echo "========================"

echo "Base name for output file (without extension):"
read BASENAME
echo "========================"
echo "========================"

OUTFILE="${BASENAME}_${METHOD}.in"

# Write header
cat << EOF > $OUTFILE
Input file for running ${METHOD} in serial

&general
 startframe=${START},
 endframe=${END},
 interval=${INTERVAL},
 keep_files=0,
/
EOF

# Write GB or PB block
if [ "$METHOD" = "GB" ]; then
cat << EOF >> $OUTFILE
&gb
 igb=5,
 saltcon=0.15,
/
EOF
fi

if [ "$METHOD" = "PB" ]; then
cat << EOF >> $OUTFILE
&pb
 istrng=0.100,
/
EOF
fi

# Decomposition block
cat << EOF >> $OUTFILE
&decomp
 idecomp=1,
 print_res="${LIGANDMASK};${RESLIST},",
 dec_verbose=1,
 csv_format=0,
/
EOF

echo "Running ANTE_MMPBSA"
ante-MMPBSA.py -p $TOP -c com4.top -r rec4.top -l LIG4.top -n :$LIGANDMASK --radii=mbondi2

echo "========================"
echo "========================"

echo "Running MM${METHOD}SA"
MMPBSA.py -O -i $OUTFILE -o MM${METHOD}SA.dat -sp $TOP -cp com4.top -rp rec4.top -lp LIG4.top -y $TRAJ > MM${METHOD}SA.log

echo "========================"
echo "========================"
echo "Done with running ${OUTFILE}"
