FROM python:3.11

# Set up VTK for headless rendering
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    mesa-utils \
    wget

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"

RUN apt-get update && \
    python -m venv ${VIRTUAL_ENV} && \
    . ${VIRTUAL_ENV}/bin/activate && \
    pip install wheel

RUN . ${VIRTUAL_ENV}/bin/activate && \
    pip install surfplot neuromaps && \
    pip uninstall -y vtk && \
    wget https://www.vtk.org/files/release/9.3/vtk_osmesa-9.3.1-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl && \
    pip install vtk_osmesa-9.3.1-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl && \
    rm vtk_osmesa-9.3.1-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl

RUN useradd --create-home splotter

USER splotter

LABEL maintainer="Philip A Cook (https://github.com/cookpa)"
LABEL description="Containerized surfplot"

ENTRYPOINT ["/bin/bash"]