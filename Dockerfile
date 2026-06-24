FROM ubuntu:20.04

# install ubuntu dependencies
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get update && \
    apt-get -y install python3-pip xvfb ffmpeg git build-essential python-opengl
RUN ln -s /usr/bin/python3 /usr/bin/python

# install microrts dependencies
RUN apt-get -y -q install wget unzip default-jdk

# install python dependencies
RUN pip install poetry
COPY pyproject.toml pyproject.toml
COPY poetry.lock poetry.lock
RUN poetry install

# copy local files
COPY ./gym_microrts /gym_microrts
COPY ./experiments /experiments
RUN poetry install
RUN poetry run python -m pip install gymnasium
COPY hello_world.py hello_world.py
COPY build.sh build.sh

COPY entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]