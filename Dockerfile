###############
# BUILD IMAGE #
###############
#FROM python:3.8.2-slim-buster AS build
FROM python:3.7 AS build

# virtualenv
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# add and install requirements
RUN pip install --upgrade pip
COPY ./requirements.txt .
RUN pip install -r requirements.txt
#################
# RUNTIME IMAGE #
#################
#FROM python:3.8.2-slim-buster AS runtime
FROM python:3.7 AS runtime

# setup user and group ids
ARG USER_ID=1000
ENV USER_ID $USER_ID
ARG GROUP_ID=1000
ENV GROUP_ID $GROUP_ID

RUN groupadd -r swuser -g 433 && \
useradd -u 431 -r -g swuser -d <homedir> -s /sbin/nologin -c "Docker image user" swuser && \
chown -R swuser:swuser <homedir>

# add non-root user and give permissions to workdir
RUN groupadd --gid $GROUP_ID user && \
          adduser user --ingroup user --gecos '' --disabled-password --uid $USER_ID && \
          mkdir -p /usr/src/app && \
          chown -R user:user /usr/src/app
          
# setup user and group ids

#ARG USER_ID=1000
#ENV USER_ID $USER_ID
#ARG GROUP_ID=1000
#ENV GROUP_ID $GROUP_ID

# add non-root user and give permissions to workdir
#RUN groupadd --gid $GROUP_ID user && \
#          adduser user --ingroup user --gecos '' --disabled-password --uid $USER_ID && \
#          mkdir -p /usr/src/app && \
#          chown -R user:user /usr/src/app

# copy from build image
COPY --chown=user:user --from=build /opt/venv /opt/venv

# set working directory
WORKDIR /usr/src/app

# switch to non-root user
USER user
# copying all files over
COPY --chown=user:user . /usr/src/app

# disables lag in stdout/stderr output
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

# Path
ENV PATH="/opt/venv/bin:$PATH"

# Expose port 
ENV PORT 8501

# Run streamlit\
CMD streamlit run app.py
