#!/bin/bash

echo "Enter stripped topology file (e.g., stripped.top):"
read stripped_top

echo "Enter stripped trajectory file (e.g., stripped.nc):"
read stripped_traj

echo "Enter start frame of trajectory file (e.g., 1):"
read startframe

echo "Enter end frame of trajectory file (e.g., 10000):"
read endframe

echo "Select analysis type:"
echo "1) RMSD"
echo "2) RMSF"
echo "3) Radius of Gyration (ROG)"
read -p "Enter choice (1/2/3): " analysis

read -p "Enter range of residue(eg. 1-10): " resid
read -p "Enter range of atom (eg. CA,CB etc.): " mask


CPPTRAJ_INPUT="cpptraj_input.in"

###############################################
# ---------------- RMSD ----------------------#
###############################################
if [ "$analysis" == "1" ]; then
    echo "RMSD selected."
    echo "Choose reference type:"
    echo "1) First frame"
    echo "2) Average structure"
    echo "3) Minimized structure"
    read -p "Enter choice (1/2/3): " refchoice

    if [ "$refchoice" == "1" ]; then
        cat > $CPPTRAJ_INPUT <<EOF
parm $stripped_top
trajin $stripped_traj $startframe $endframe
rms first out rmsd_firstframe.dat :$resid@$mask
run
EOF

    elif [ "$refchoice" == "2" ]; then
        cat > $CPPTRAJ_INPUT <<EOF
parm $stripped_top
trajin $stripped_traj $startframe $endframe
rms first :$resid@$mask
average av.pdb pdb nobox
run

reference av.pdb
trajin $stripped_traj $startframe $endframe
rms reference out rmsd_avg.dat :$resid@$mask
run
EOF

    elif [ "$refchoice" == "3" ]; then
        read -p "Enter solvated topology file: " solvtop
        read -p "Enter minimized restart file: " minrst
        read -p "Enter ions to strip (eg. Na+ etc.): " ions

        cat > $CPPTRAJ_INPUT <<EOF
# --- Strip minimized structure ---
parm $solvtop
trajin $minrst
strip :WAT,$ions
trajout min_dry.rst restart
run
clear all

# --- Load stripped system ---
parm $stripped_top
trajin $stripped_traj $startframe $endframe

# --- Use dry minimized structure as reference ---
reference min_dry.rst
rms reference out rmsd_minimized.dat :$resid@$mask
run
EOF
    fi
fi

###############################################
# ---------------- RMSF ----------------------#
###############################################
if [ "$analysis" == "2" ]; then
    echo "RMSF selected."

    cat > $CPPTRAJ_INPUT <<EOF
parm $stripped_top
trajin $stripped_traj $startframe $endframe

rms first :$resid@$mask
average av.pdb pdb nobox
run

reference av.pdb
trajin $stripped_traj $startframe $endframe
rms reference :$resid@$mask
atomicfluct out rmsf.dat :$resid@$mask byres
run
EOF
fi

###############################################
# ---------------- ROG -----------------------#
###############################################
if [ "$analysis" == "3" ]; then
    echo "ROG selected."
    echo "Choose reference type:"
    echo "1) First frame"
    echo "2) Average structure"
    echo "3) Minimized structure"
    read -p "Enter choice (1/2/3): " refchoice

    if [ "$refchoice" == "1" ]; then
        cat > $CPPTRAJ_INPUT <<EOF
parm $stripped_top
trajin $stripped_traj $startframe $endframe
rms first :$resid@$mask
radgyr out rog_firstframe.dat
run
EOF

    elif [ "$refchoice" == "2" ]; then
        cat > $CPPTRAJ_INPUT <<EOF
parm $stripped_top
trajin $stripped_traj $startframe $endframe
rms first :$resid@$mask
average av.pdb pdb nobox
run

reference av.pdb
trajin $stripped_traj $startframe $endframe
rms reference :$resid@$mask
radgyr out rog_avg.dat
run
EOF

    elif [ "$refchoice" == "3" ]; then
        read -p "Enter solvated topology file: " solvtop
        read -p "Enter minimized restart file: " minrst
        read -p "Enter ions to strip (eg. Na+ etc.): " ions

        cat > $CPPTRAJ_INPUT <<EOF
# --- Strip minimized structure ---
parm $solvtop
trajin $minrst
strip :WAT,$ions
trajout min_dry.rst restart
run
clear all

# --- Load stripped system ---
parm $stripped_top
trajin $stripped_traj $startframe $endframe

# --- Use dry minimized structure as reference ---
reference min_dry.rst
rms reference :$resid@$mask
radgyr out rog_minimized.dat
run
EOF
    fi
fi

###############################################
# Run CPPTRAJ
###############################################
echo "Running CPPTRAJ..."
cpptraj -i $CPPTRAJ_INPUT
echo "Done."

