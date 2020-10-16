#!/bin/bash

git config --global user.email "dominic@davis-foster.co.uk"
git config --global user.name "Dominic Davis-Foster"

# Install requirements
sudo apt update
sudo apt install -y python3-venv python3-pip || exit 1

# Create and activate venv
python3 -m venv /home/vagrant/venv
source /home/vagrant/venv/bin/activate || exit 1

# Install remaining requirements
python3 -m pip install pip setuptools wheel --upgrade || exit 1
python3 -m pip install nbconvert jupyter-client ipykernel --upgrade  || exit 1
python3 -m pip install -r requirements.txt --upgrade || exit 1
python3 -m pip install . --upgrade || exit 1

# Change to Notebooks branch
git checkout -b Notebooks-v2 || exit 1

cd pyms-demo/jupyter || exit 1

# Run once to ensure output files exist
jupyter nbconvert --to notebook --inplace --execute Multiple_Experiments.ipynb

# Render notebooks and stage
for file in *.ipynb; do
  jupyter nbconvert --clear-output --inplace "$file"
  jupyter nbconvert --to notebook --inplace --execute "$file"
  git stage "$file"
done

# Commit and push
git commit -m "Re-rendered Jupyter Notebooks" || exit 1
git push --set-upstream origin Notebooks-v2 || exit 1

exit 0
