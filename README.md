# Containerized JupyterLab

Here we do a Jupyter/Python kernel setup

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p ${HOME}/miniconda3
${HOME}/miniconda3/bin/conda init bash
${HOME}/miniconda3/bin/conda config --set auto_activate_base false
```

```bash
conda install -n base jupyterlab nb_conda_kernels
conda create -n plotting -c conda-forge ipykernel matplotlib
```

inside a container environment.

You only need a local installation of Docker to get started. Download the `Dockerfile` and execute this

```bash
docker image build . -t jupyter
```

in the directory in which the `Dockerfile` is located.

You can start a container Bash session with

```bash
docker run -p 8888:8888 -v $(pwd):/home/jupyter/persistent -it jupyter /bin/bash
```

in the directory, in which e.g. your already existing Jupyter notebooks are located.

In the container execute `./jupyterlab.sh` to start JupyterLab. To access your notebooks via the containerized JupyterLab session, copy and paste the localhost URL into your local browser.

## Notes/Disclaimer

To keep single image sizes as small as possible one might actually not set up several conda environments, e.g. Python kernels, in a single container. Each kernel should rather get its own container.

However, this Docker container was designed to reproduce the "one JupyterLab instance accesses them all" kernel user experience, that you get by a typical OS-based installation. Thus, it could be used as a drop-in replacement. It should be added though, that what is currently presented here is rather a prototype, than an actual workflow that is ready and can be recommended for productive use.

## References

* https://github.com/jupyter/docker-stacks
* https://github.com/ContinuumIO/docker-images
* https://github.com/krallin/tini/blob/master/README.md
* https://engineeringblog.yelp.com/2016/01/dumb-init-an-init-for-docker.html
* https://stackoverflow.com/questions/43122080/how-to-use-init-parameter-in-docker-run
