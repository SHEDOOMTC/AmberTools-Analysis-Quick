#!/bin/bash

echo "=== CPPTRAJ Native Contacts Script Builder ==="
echo "========================"
echo "========================"

# Ask for topology
read -p "Enter topology file (e.g., prmtop): " TOPO
echo "========================"
echo "========================"

# Ask for trajectory
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

# Ask for residue masks
read -p "Enter active site residues mask (e.g., 14-17,34,36): " MASK1
read -p "Enter ligand mask (e.g., 390): " MASK2
echo "========================"
echo "========================"

# Ask for cutoff
read -p "Enter cutoff distance in armstrong (e.g., 3.0): " CUTOFF
echo "========================"
echo "========================"

# Ask for base output name
read -p "Enter base name for output files (e.g., contact): " BASE
echo "========================"
echo "========================"

# Output file
OUTFILE="${BASE}_nativecontacts.in"

cat <<EOF > $OUTFILE
parm $TOPO
trajin $TRAJ
$REF_LINE

nativecontacts name NC1 :$MASK1&!@H= :$MASK2&!@H= \\
    writecontacts ${BASE}-contacts.dat \\
    byresidue out ${BASE}.residue.dat mindist maxdist \\
    distance $CUTOFF reference map mapout ${BASE}.map.agr \\
    contactpdb ${BASE}.native.pdb \\
    series seriesout ${BASE}.native.dat \\
    savenonnative seriesnnout ${BASE}.nonnative.dat nncontactpdb ${BASE}.nonnative.pdb \\
    resseries sum resseriesout ${BASE}.resseries.dat

run
EOF

echo "CPPTRAJ script written to: $OUTFILE"
echo "========================"
echo "========================"

echo "Running CPPTRAJ script"

cpptraj -i $OUTFILE
