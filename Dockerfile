FROM ubuntu:18.04

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3 \
 && rm -rf Miniconda3-latest-Linux-x86_64.sh \
 && source $HOME/miniconda3/bin/activate base \
 && conda install jupyterlab nb_conda_kernels \
 && conda create -n analysis -c conda-forge ipykernel numpy netCDF4 scipy matplotlib pandas \
 && conda clean -a -d
