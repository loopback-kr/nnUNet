FROM loopbackkr/pytorch:2.0.0-cuda11.7-cudnn8-devel

ARG USER
ARG XDG_RUNTIME_DIR
RUN groupadd --gid $(basename $XDG_RUNTIME_DIR) $USER &&\
    useradd --uid $(basename $XDG_RUNTIME_DIR) --gid $(basename $XDG_RUNTIME_DIR) -m $USER &&\
    echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER &&\
    chmod 0440 /etc/sudoers.d/$USER

WORKDIR /workspace
ENV PYTHONPATH=/workspace
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ENV nnUNet_raw="/workspace/nnUNet_raw"
ENV nnUNet_preprocessed="/workspace/nnUNet_preprocessed"
ENV nnUNet_results="/workspace/nnUNet_results"

RUN chown $USER:$USER /workspace
USER $USER