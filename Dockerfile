FROM elixir:1.4.5-slim
MAINTAINER homi

RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  nodejs \
  npm \
  mysql-client \
  inotify-tools \
  git \
  make \
  imagemagick \
  curl && \
  rm -rf /var/lib/apt/lists/* && \
  npm cache clean && \
  npm install n -g && \
  n stable && \
  ln -sf /usr/local/bin/node /usr/bin/node && \
  apt-get purge -y nodejs npm

#install mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb http://download.mono-project.com/repo/ubuntu trusty main" | tee /etc/apt/sources.list.d/mono-official.list && \
    apt-get update

# Add erlang-history
RUN git clone -q https://github.com/ferd/erlang-history.git && \
    cd erlang-history && \
    make install && \
    cd - && \
    rm -fR erlang-history


EXPOSE 4000

CMD ["sh", "-c", "mix deps.get && mix phoenix.server"]
