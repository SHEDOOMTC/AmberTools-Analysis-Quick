#!/bin/bash

echo "Enter parm file:"
read PARM

echo "Enter trajectory file:"
read TRAJ

echo "Enter start frame:"
read START

echo "Enter end frame:"
read END

echo "Enter Stride:"
read STRIDE

echo "Select clustering algorithm:"
echo "1) hieragglo"
echo "2) kmeans"
echo "3) dbscan"
echo "4) average-linkage (hierarchical)"
read ALG_CHOICE

case $ALG_CHOICE in
  1) ALG="hieragglo";;
  2) ALG="kmeans";;
  3) ALG="dbscan";;
  4) ALG="hieragglo averagelinkage";;
  *) echo "Invalid choice"; exit 1;;
esac

echo "Enter number of clusters:"
read NCLUST

echo "Enter residue range (e.g., 1-389):"
read RESRANGE

echo "Enter atom masks (comma-separated, e.g., C,N,O,CA,CB):"
read ATOMS

# Output file
INFILE="cluster_input.in"

cat <<EOF > $INFILE
parm $PARM

trajin $TRAJ $START $END $STRIDE

cluster c1 \\
  $ALG clusters $NCLUST \\
  rms :$RESRANGE@$ATOMS&!@H= \\
  sieve 10 random \\
  out cnumvtime.dat \\
  summary summary.dat \\
  info info.dat \\
  cpopvtime cpopvtime.agr normframe \\
  repout rep repfmt pdb \\
  singlerepout singlerep.nc singlerepfmt netcdf \\
  avgout avg avgfmt pdb

run
EOF

echo "CPPTRAJ input file generated: $INFILE"


echo "Running cpptraj..."
cpptraj -i cluster_input.in

echo "Analysis complete!"
