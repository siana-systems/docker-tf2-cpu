#------------------------------------------------------------------------------
# @author: SIANA Systems
# @date: 04/2018 (original)
#
# Docker used for training models for ST Cube.AI
#  => TF:1.15 + Keras:2.3.1
#
# IMPORTANT: a copy of the Cube.AI must be present under: ./cubeai
#
# Based on Keras dockerfile (for CPU-only):
# ref: https://github.com/keras-team/keras/issues/8667
#------------------------------------------------------------------------------

FROM debian:buster

# create 'siana' user...
ENV NB_USER siana
ENV NB_UID 1000
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER

# Install missing dependencies from debian
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    bzip2 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      bzip2 \
      g++ \
      git \
      graphviz \
      libgl1-mesa-glx \
      libhdf5-dev \
      openmpi-bin \
      nano \
      wget && \
    rm -rf /var/lib/apt/lists/*

# Install conda
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

RUN wget --quiet --no-check-certificate https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh && \
    echo "c59b3dd3cad550ac7596e0d599b91e75d88826db132e4146030ef471bb434e9a *Miniconda3-4.2.12-Linux-x86_64.sh" | sha256sum -c - && \
    /bin/bash /Miniconda3-4.2.12-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-4.2.12-Linux-x86_64.sh && \
    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh

RUN chown $NB_USER $CONDA_DIR -R && \
    mkdir -p /src && \
    chown $NB_USER /src

USER $NB_USER

# install Python...
ARG python_version=3.6
RUN conda install -y python=${python_version} && \
    pip install --upgrade pip

# install TensorFlow (ignore Six dependency => already installed thru distutils)
RUN pip install --ignore-installed six \
      invoke         \
      sklearn_pandas \
      tensorflow

# install python modules...
RUN conda install \
      bcolz \
      h5py \
      matplotlib \
      mkl \
      nose \
      notebook \
      Pillow \
      pandas \
      pydot \
      pygpu \
      pyyaml \
      scikit-learn

# install audio processing lib
RUN conda install -c conda-forge librosa

RUN conda clean -yt

ENV PYTHONPATH='/src/:$PYTHONPATH'

WORKDIR /src

EXPOSE 8888

CMD jupyter notebook --port=8888 --ip=0.0.0.0

