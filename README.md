# AmberTools-Analysis-Quick
This is an attempt to deposit the things I have learnt on how to do post-MD analysis on Amber

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
The script will request several input paramters interactively like your parm file, traj prefix, starting traj index, traj format, number of traj files, number of frames to process per traj, ions to strip, water residue name.

It assumes your traj files are named sequentially starting from 0 or 1 with a prefix and then an extension

You will have a stripped topology and stripped combined traj in .nc format in the output

--------

**RMS-fluc-deviations:**

*Quickly analyze rmsd, rmsf, rog, globally and in the active site or specific regions*

Usage:

```bash
./hhhhhhhhhh

```
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
./hhhhhhhhhh

```
-----------

**Weda-dimension**

*Reduce dimension and extract the most important motions*

Usage:

```bash
./hhhhhhhhhh

```
------------

**Okachasi-mkpa-structure**

*Collect the most representative structure in your system*

Usage:

```bash
./hhhhhhhhhh

```
------------

**Ike-eji-aru-oru computation**

*Compute the fre energy surface of your system*

Usage:

```bash
./hhhhhhhhhh

```
-----------

**Kontakti-na-hydrogen-bondi-analysis**

*Analyze the most important contacts and hydrogen bonding in your systems*

Usage:

```bash
./hhhhhhhhhh

```
-----------

