#!/bin/bash

MINICONDA_BIN=$HOME/miniconda/bin

for pkg in pytest python-gflags tqdm ipython pyzmq tornado pyreadline jsonschema decorator jinja2
do
    $MINICONDA_BIN/pip install $pkg
done

# Install pycuda
wget https://pypi.python.org/packages/source/p/pycuda/pycuda-2016.1.tar.gz -O /tmp/pycuda-2016.1.tar.gz
tar -xvf /tmp/pycuda-2016.1.tar.gz -C /tmp
cd /tmp/pycuda-2016.1
$MINICONDA_BIN/python configure.py --cuda-root=/usr/local/cuda-7.5
make install
