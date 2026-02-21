# AmberTools-Analysis-Quick
This is an attempt to deposit the things I have learnt on how to do post-MD analysis on Amber

The scripts here are interactive and automated to allow the user more control over the inputs and outputs

---------

**njikota-Traj:**

*combine your trajectories*

A script to help you seamlessly combine your amber trajectory files

**Usage:**

```bash
#Clone repository
git clone https://github.com/SHEDOOMTC/AmberTools-Analysis-Quick.git
#copy njikota-Traj.sh from njikota-Traj/ into your working directory
# Make executable
chmod +x njikota-Traj.sh
#run
./njikota-Traj.sh

```
1.  The script will request several input paramters interactively like your parm file, traj prefix, starting traj index, traj format, number of traj files, number of frames to process per traj, ions to strip, water residue name.

2.  It assumes your traj files are named sequentially starting from 0 or 1 with a prefix and then an extension

3.  You will have a stripped topology and stripped combined traj in .nc format in the output

--------

**rms-fluc-deviations:**

*Quickly analyze rmsd, rmsf, rog, globally and in the active site or specific regions*

Usage:

```bash
#Clone repository
git clone https://github.com/SHEDOOMTC/AmberTools-Analysis-Quick.git
#copy rms-fluc-deviations.sh from rms-fluc-deviations/ into your working directory
# Make executable
chmod +x rms-fluc-deviations.sh
#run
./rms-fluc-deviations.sh

```

1.  The script will first request input paramters interactively like your stripped parm and trajectory files, starting frame, ending frame.

2.  Then you will choose one of "RMSD" "RMSF" or "ROG" analysis and also enter residue range (for active site or domain analysis) and atom masks
  
3.  For any of "RMSD" or ROG" you choose, you will have to further select your reference structure (First frame, average structure or the minimized structure)

4.  If you choose the minimized strucutre, you will be requested to enter a solvated topology and restart file of the minimization step (since the restart file is still solvated). This step is necessary to generate a stripped minimized structure to be used as reference

5.  The names of the output files are hardcoded but usually reads "rmsd_minimized.dat" for rmsd using the minimized structure as reference

6.  Any other detailed output needed will require the modification of the script



---------

**Higher-fluctuations**

*Measure dynamic correlations, secondary structure changes etc*

Usage:

```bash
./hhhhhhhhhh

```
----------

**otu-dimension-cord-analys**

*Track your reaction cordinate such as distances, angles and torsions*

Usage:

```bash

#Clone repository
git clone https://github.com/SHEDOOMTC/AmberTools-Analysis-Quick.git
#copy otu-dimension-cord-analys.sh from otu-dimension-cord-analys/ into your working directory
# Make executable
chmod +x otu-dimension-cord-analys.sh
#run
./otu-dimension-cord-analys.sh

```

1.  The script will request several input paramters interactively like your parm file, traj file, start frame and end frame

2.  It also request to choose one of distance, angle or torsion to compute

3.  You can enter the masks you want to use (eg. 540@CA etc.)

4.  You finally choose the name of the output file

5.  This uses only atoms in its computation and cannot handle centre of mass calculations



-----------

**nweda-dimension-pca**

*Reduce dimension and extract the most important motions along n principal components (PCA)*

Usage:

```bash
#Clone repository
git clone https://github.com/SHEDOOMTC/AmberTools-Analysis-Quick.git
#copy nweda-dimension-pca.sh from nweda-dimension-pca/ into your working directory
# Make executable
chmod +x nweda-dimension-pca.sh
#run
./nweda-dimension-pca.sh

```

1.  The script will request several input paramters interactively like your parm file, traj file, start frame and end frame and name of the output file

2.  It also request to choose the stride for performing the cutting step (for computational efficiency; choose between 100-500)

4.  It will also request for the number of principal vectors to compute

5.  It outputs two key .dat files for the principal components and their contributions 

*Note*

The diagonalization of the matrix uses only the @CA atoms; if needed, you may have to edit the script

------------

**strucuture-kachasi-mkpa**

*Collect the most representative structure in your system through clustering*

Usage:

```bash

#Clone repository
git clone https://github.com/SHEDOOMTC/AmberTools-Analysis-Quick.git
#copy strucuture-kachasi-mkpa.sh from strucuture-kachasi-mkpa/ into your working directory
# Make executable
chmod +x strucuture-kachasi-mkpa.sh
#run
./strucuture-kachasi-mkpa.sh

```


1.  The script will request several input paramters interactively like your parm file, traj file, start frame and end frame, and stride 

2.  It also request to choose the clustering method (hieragglo, kmeans, dbscan, average-linkage) and the number of cluster expected

3.  You also enter the residue range (eg. 1-400) and the atom masks (eg. e.g., C,N,O,CA,CB)

4.  Output files are hard coded to generate cluster number vs time, cluster population vs time, representative ad average strucutre of each cluster, and a summary file of clusters (number of frames, rmsd etc.)

 *Note:* 
 
 This uses sieve of 10 internally and the script must be edited if there is need to change it.


------------

**Ike-eji-aru-oru computation**

*Compute the fre energy surface of your system*

Usage:

```bash


```
-----------

**Kontakti-na-hydrogen-bondi-analysis**

*Analyze the most important contacts and hydrogen bonding in your systems*

Usage:

```bash
./hhhhhhhhhh

```
-----------

