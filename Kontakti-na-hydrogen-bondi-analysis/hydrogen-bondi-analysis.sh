#!/bin/bash

echo "=== CPPTRAJ HBond Analysis Script Builder ==="
echo "========================"
echo "========================"

# Topology
read -p "Enter topology file (e.g., prmtop): " TOPO
echo "========================"
echo "========================"

# Trajectory
read -p "Enter trajectory file (e.g., com_Dry.nc): " TRAJ
echo "========================"
echo "========================"

# Reference choice
echo "Choose reference structure:"
echo "  1) First frame of trajectory"
echo "  2) Minimized structure file"
read -p "Enter choice (1 or 2): " REFCHOICE
echo "========================"
echo "========================"

if [[ "$REFCHOICE" == "1" ]]; then
    REF_LINE="reference $TRAJ 1"
elif [[ "$REFCHOICE" == "2" ]]; then
    read -p "Enter minimized structure file (rst/pdb/inpcrd): " REF
    REF_LINE="reference $REF"
else
    echo "Invalid choice. Exiting."
    exit 1
fi

echo "========================"
echo "========================"
# Residue masks
read -p "Enter active site residues mask (eg., 10-30,34): " MASK1
read -p "Enter Ligand mask (eg., 390): " MASK2

echo "========================"
echo "========================"
# Base name
read -p "Enter base name for output files: " BASE

# Output file
OUTFILE="${BASE}_hbonds.in"

cat <<EOF > $OUTFILE
parm $TOPO
trajin $TRAJ
$REF_LINE

# -------------------------
# HBonds: Residues → Ligand
# -------------------------
hbond donormask :$MASK1 acceptormask :$MASK2 angle 135 dist 3.5 \\
    out ${BASE}_res2lig_hb.dat avgout ${BASE}_res2lig_hb_avg.dat \\
    printatomnum nointramol \\
    series uuseries ${BASE}_res2lig_hb_series.dat

run

# -------------------------
# HBonds: Ligand → Residues
# -------------------------
hbond donormask :$MASK2 acceptormask :$MASK1 angle 135 dist 3.5 \\
    out ${BASE}_lig2res_hb.dat avgout ${BASE}_lig2res_hb_avg.dat \\
    printatomnum nointramol \\
    series uuseries ${BASE}_lig2res_hb_series.dat

run
EOF

echo "========================"
echo "========================"
echo "Running CPPTRAJ script"
cpptraj -i $OUTFILE
