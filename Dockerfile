FROM ubuntu:18.04


# Setup host environment.
# Do as privileged root user.

RUN apt-get update --yes \
 && apt-get install --yes --no-install-recommends wget \
 && rm -rf /var/lib/apt/lists/*


# Install a container init system.
# Prepare non-microservice use.

ARG TINI_VERSION=v0.19.0

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini


# Add un-privileged user.

RUN useradd -g users -s /bin/bash --create-home jupyter


# Install JupyterLab and Python kernels as un-privileged user.

USER jupyter

ARG MINICONDA_VERSION=Miniconda3-latest-Linux-x86_64.sh

RUN wget https://repo.anaconda.com/miniconda/${MINICONDA_VERSION} \
     --no-check-certificate --quiet --directory-prefix ${HOME} \
 && bash ${HOME}/${MINICONDA_VERSION} -b -p ${HOME}/miniconda3 \
 && rm -rf ${HOME}/${MINICONDA_VERSION} \
 && ${HOME}/miniconda3/bin/conda clean --all --yes

RUN ${HOME}/miniconda3/bin/conda init bash \
 && ${HOME}/miniconda3/bin/conda config --set auto_activate_base false

RUN ${HOME}/miniconda3/bin/conda install -n base jupyterlab nb_conda_kernels \
 && ${HOME}/miniconda3/bin/conda create -n plotting -c conda-forge ipykernel matplotlib \
 && ${HOME}/miniconda3/bin/conda clean --all --yes


# Change to home directory.
# Add JupyterLab start-up script.

WORKDIR /home/jupyter

RUN echo '#!/bin/bash' > jupyterlab.sh \
 && echo 'eval "$(conda shell.bash hook)"' >> jupyterlab.sh \
 && echo 'conda activate base &&' >> jupyterlab.sh \
 && echo 'jupyter lab --no-browser --ip=0.0.0.0' >> jupyterlab.sh \
 && chmod +x jupyterlab.sh


# Convenience area.

# Add persistent storage mount point.
RUN mkdir persistent

# Set default JupyterLab terminal.
ENV SHELL /bin/bash


# Always enter with init system.

ENTRYPOINT ["/tini", "--"]
