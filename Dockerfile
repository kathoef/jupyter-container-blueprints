FROM ubuntu:18.04

RUN apt-get update --yes \
 && apt-get install --yes --no-install-recommends wget \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh --no-check-certificate \
 && bash Miniconda3-latest-Linux-x86_64.sh -b -p miniconda3 \
 && rm -rf Miniconda3-latest-Linux-x86_64.sh \
 && /miniconda3/bin/activate base \
 && conda install jupyterlab nb_conda_kernels --yes \
 && conda create -n analysis -c conda-forge ipykernel numpy netCDF4 scipy matplotlib pandas --yes \
 && conda clean -a --yes
