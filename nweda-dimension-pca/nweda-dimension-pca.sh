#!/bin/bash

echo "=== CPPTRAJ PCA WORKFLOW ==="

# -----------------------------
# Interactive user input
# -----------------------------
read -p "Enter parm file (.parm7): " PARM
read -p "Enter first trajectory file: " TRAJ1
read -p "How many eigenvectors to extract? " NVECS
read -p "Enter Start frame: " STFRAME
read -p "Enter End frame: " ENDFRAME
read -p "Enter the Stride for the cutting step (Choose between 100-500): " STRIDE
read -p "Output PCA Filename: " PCA_PROJ_OUT

# -----------------------------
# Step 1: Strip
# -----------------------------
cat > strip.ptrj <<EOF
parm $PARM
trajin $TRAJ1 $STFRAME $ENDFRAME
trajout strip.bps binpos nobox
run
EOF

cpptraj -i strip.ptrj

# -----------------------------
# Step 2: Align-min
# -----------------------------
cat > align-min.ptrj <<EOF
parm $PARM
trajin strip.bps 1 1
reference strip.bps 1
trajin strip.bps
trajout almin.bps binpos nobox
rms reference out rms-min.dat @CA
average av.pdb * pdb nobox
run
EOF

cpptraj -i align-min.ptrj
# -----------------------------
# Step 3: Align-average
# -----------------------------
cat > align-av.ptrj <<EOF
parm $PARM
reference av.pdb
trajin almin.bps
trajout alav.bps binpos nobox
rms reference out rms-av.dat @CA
run
EOF

cpptraj -i align-av.ptrj

# -----------------------------
# Step 4: Cut trajectory
# -----------------------------
cat > cut.ptrj <<EOF
parm $PARM
trajin alav.bps $STFRAME $ENDFRAME $STRIDE
trajout alav-sm.bps binpos nobox
run
EOF

cpptraj -i cut.ptrj

# -----------------------------
# Step 5: Convert to CRD
# -----------------------------
cat > conv.ptrj <<EOF
parm $PARM
trajin alav-sm.bps
trajout alav-sm.crd trajectory nobox
run
EOF

cpptraj -i conv.ptrj

# -----------------------------
# Step 6: PCA
# -----------------------------
cat > pca.ptrj <<EOF
parm $PARM
trajin alav.bps
matrix covar name covmat out covmat-ca.dat @CA
analyze matrix covmat out evecs.dat vecs $NVECS
run
EOF

cpptraj -i pca.ptrj

# -----------------------------
# Step 7: Extract contributions
# -----------------------------
echo "Extracting PCA contributions..."
grep "^[ ]*[1-$NVECS] " evecs.dat | \
awk -v N=$NVECS '
BEGIN{t=0}
{e[$1]=$2; t+=$2}
END{
  for(i=1;i<=N;i++){
    printf("PC%d: %f (%s%%)\n", i, e[i], sprintf("%.1f",e[i]/t*100));
  }
}' > ${PCA_PROJ_OUT}_CONTRIB.dat

# -----------------------------
# Step 8: Projection (full)
# -----------------------------
cat > proj.ptrj <<EOF
parm $PARM
trajin alav.bps
projection modes evecs.dat out pcas beg 1 end $NVECS @CA
run
EOF

cpptraj -i proj.ptrj

# -----------------------------
# Step 9: Projection (smoothed)
# -----------------------------
cat > projs.ptrj <<EOF
parm $PARM
trajin alav-sm.bps
projection modes evecs.dat out ${PCA_PROJ_OUT}-${NVECS} beg 1 end $NVECS @CA
run
EOF

cpptraj -i projs.ptrj

# -----------------------------
# Step 10: Convert to .dat
# -----------------------------

{
    # Print header line
    printf "#"
    for ((i=1; i<=NVECS; i++)); do
        printf "%sPC%d" "$( [ $i -eq 1 ] || echo -e "\t" )" "$i"
    done
    printf "\n"

    # Print data rows
    sed '1,2d' ${PCA_PROJ_OUT}-${NVECS} | \
    awk -v N=$NVECS '{
        for(i=2; i<=N+1; i++){
            printf "%s%s", $i, (i < N+1 ? "\t" : "\n")
        }
    }'
} > ${PCA_PROJ_OUT}-${NVECS}.dat


echo ""
echo "=== DONE ==="
echo "Generated:"
echo "  ${PCA_PROJ_OUT}-${NVECS}-CONTRIB.dat"
echo "  ${PCA_PROJ_OUT}-${NVECS}.dat"
echo ""
