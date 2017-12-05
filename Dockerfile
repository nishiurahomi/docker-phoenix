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
RUN apt install wget && \
    wget http://download.mono-project.com/repo/xamarin.gpg && \
    apt-key add xamarin.gpg && \
    rm xamarin.gpg && \
    echo "deb http://download.mono-project.com/repo/debian wheezy main" > /etc/apt/sources.list.d/mono-xamarin.list && \
    apt-get update -q && \
    apt-get -y -q install mono-complete

# Add erlang-history
RUN git clone -q https://github.com/ferd/erlang-history.git && \
    cd erlang-history && \
    make install && \
    cd - && \
    rm -fR erlang-history


USER elixir

EXPOSE 4000

CMD ["sh", "-c", "mix deps.get && mix phoenix.server"]
