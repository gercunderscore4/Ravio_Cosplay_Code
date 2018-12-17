#! /bin/bash
# This script is for automating the make process.

echo ''
echo '################ MOVE'
cd ~/Ravio_Cosplay_Code/prototype_rod

echo ''
echo '################ CLEAN'
git reset HEAD --hard
make clean

echo ''
echo '################ UPDATE'
git pull

echo ''
echo '################ MAKE'
make install

echo ''
echo '################ DONE'
