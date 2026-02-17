
#!/usr/bin/env bash

# Interactive cpptraj input script generator for trajectory processing

echo "=== cpptraj trajectory processing setup ==="

read -p "Enter parameter/topology file (e.g., com_solvated.top): " parmfile
echo '==='
echo '==='
echo '==='
read -p "Enter trajectory prefix (e.g., md, prod, run, traj_): " prefix
echo '==='
echo '==='
echo '==='
read -p "Enter starting index (e.g., 0 or 1): " startnum
echo '==='
echo '==='
echo '==='
read -p "Enter trajectory format (mdcrd or nc): " trajfmt
echo '==='
echo '==='
echo '==='
read -p "Enter number of trajectory files: " ntraj
echo '==='
echo '==='
echo '==='
read -p "Enter number of frames to process per file (0 for all): " nframes
echo '==='
echo '==='
echo '==='
read -p "Enter ions to strip (comma-separated, e.g., Na+,Cl-; empty for none): " ions
echo '==='
echo '==='
echo '==='
read -p "Enter water residue name (default WAT): " water
water=${water:-WAT}

# Output prefix always "stripped"
outprefix="stripped"

# Generate cpptraj script
cat > process_trajectories.in << EOF
# Load topology
parm ${parmfile}

EOF

# Generate trajin commands
endnum=$((startnum + ntraj - 1))

for i in $(seq ${startnum} ${endnum}); do
    trajfile="${prefix}${i}.${trajfmt}"

    # Warn if file missing
    if [ ! -f "${trajfile}" ]; then
        echo "WARNING: Trajectory file ${trajfile} not found!"
    fi

    if [ ${nframes} -eq 0 ]; then
        echo "trajin ${trajfile}" >> process_trajectories.in
    else
        echo "trajin ${trajfile} 1 ${nframes}" >> process_trajectories.in
    fi
done

cat >> process_trajectories.in << EOF

# Fix periodic boundary artifacts
autoimage

EOF

# Strip water and optionally ions
if [ -z "${ions}" ]; then
    echo "strip :${water} outprefix ${outprefix}" >> process_trajectories.in
else
    echo "strip :${water},${ions} outprefix ${outprefix}" >> process_trajectories.in
fi

cat >> process_trajectories.in << EOF

# Save processed trajectory
trajout ${outprefix}.nc netcdf

EOF

echo "Running cpptraj with generated script..."
cpptraj -i process_trajectories.in

echo "Processing complete! Output: ${outprefix}.nc"
