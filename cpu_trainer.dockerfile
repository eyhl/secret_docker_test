# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the \"License\");
# you may not use this file except in compliance with the License.\n",
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an \"AS IS\" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Dockerfile-gpu
FROM python:3.8.12-bullseye

# Installs necessary dependencies.
RUN apt-get update && apt-get install -y --no-install-recommends \
         wget \
         curl \
         #python3.8 \
        ca-certificates && \
     rm -rf /var/lib/apt/lists/*

# RUN ln -s /usr/bin/python3.8 /usr/bin/python3
COPY ./requirements.txt /.
COPY ./setup.py /.

# Installs pip.
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && \
    pip install -e . python-dotenv \
    src \
    setuptools \
    wandb && \
    #pip install setuptools && \
    rm get-pip.py

WORKDIR /root

RUN wget -nv \
    https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz && \
    mkdir /root/tools && \
    tar xvzf google-cloud-sdk.tar.gz -C /root/tools && \
    rm google-cloud-sdk.tar.gz && \
    /root/tools/google-cloud-sdk/install.sh --usage-reporting=false \
        --path-update=false --bash-completion=false \
        --disable-installation-options && \
    rm -rf /root/.config/* && \
    ln -s /root/.config /config && \
    # Remove the backup directory that gcloud creates
    rm -rf /root/tools/google-cloud-sdk/.install/.backup

# Path configuration
ENV PATH $PATH:/root/tools/google-cloud-sdk/bin -

# Make sure gsutil will use the default service account
RUN echo '[GoogleCompute]\nservice_account = default' > /etc/boto.cfg

RUN pip install "python-dotenv[cli]"

# Copies the trainer code 
RUN mkdir /root/project
WORKDIR /root/project

# Copies relevant files
COPY entrypoint.sh /root/project/entrypoint.sh
COPY vars.env /root/project/vars.env
RUN echo $KEY
ENV PYTHONPATH "${PYTHONPATH}:/root/project"
ARG YOUR_API_KEY=local
ENV YOUR_API_KEY ${YOUR_API_KEY}

# Sets up the entry point to invoke the trainer.
ENTRYPOINT ["sh", "entrypoint.sh"]
# ENTRYPOINT ["python3", "-u", "/root/project/src/models/train_model.py"]export YOUR_API_KEY= (my key, secret!)