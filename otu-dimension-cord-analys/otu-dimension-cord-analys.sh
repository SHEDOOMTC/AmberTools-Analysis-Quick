#!/usr/bin/env bash

echo "=== cpptraj distance/angle/torsion analysis ==="

read -p "Enter topology file: " parmfile
read -p "Enter trajectory file: " trajfile
read -p "Enter start frames (0 for all): " startframe
read -p "Enter end frame: " endframe

echo
echo "Select analysis type:"
echo "1) Distance"
echo "2) Angle"
echo "3) Torsion"
read -p "Choose 1/2/3: " choice

case $choice in
    1)
        analysis="distance"
        read -p "Enter atom mask 1: " m1
        read -p "Enter atom mask 2: " m2
        ;;
    2)
        analysis="angle"
        read -p "Enter atom mask 1: " m1
        read -p "Enter atom mask 2: " m2
        read -p "Enter atom mask 3: " m3
        ;;
    3)
        analysis="dihedral"
        read -p "Enter atom mask 1: " m1
        read -p "Enter atom mask 2: " m2
        read -p "Enter atom mask 3: " m3
        read -p "Enter atom mask 4: " m4
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

read -p "Enter output filename (e.g., dist.dat): " outfile

# Generate cpptraj script
cat > analysis.in << EOF
parm ${parmfile}
EOF

echo "trajin ${trajfile} ${startframe} ${endframe}" >> analysis.in


echo >> analysis.in

case $choice in
    1)
        echo "distance d1 :${m1} :${m2} out ${outfile}" >> analysis.in
        ;;
    2)
        echo "angle a1 :${m1} :${m2} :${m3} out ${outfile}" >> analysis.in
        ;;
    3)
        echo "dihedral t1 :${m1} :${m2} :${m3} :${m4} out ${outfile}" >> analysis.in
        ;;
esac

echo >> analysis.in
echo "run" >> analysis.in

echo "Running cpptraj..."
cpptraj -i analysis.in

echo "Analysis complete! Output: ${outfile}"
