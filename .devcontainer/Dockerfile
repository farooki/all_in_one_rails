FROM ruby:3.4.6-bookworm

ARG NODE_MAJOR=20

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      git \
      gnupg2 \
      libpq-dev \
      libvips \
      libyaml-dev \
      pkg-config && \
    curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID --create-home --shell /bin/bash $USERNAME

RUN mkdir -p /usr/local/bundle && chown -R $USERNAME:$USERNAME /usr/local/bundle

ENV BUNDLE_PATH=/usr/local/bundle \
    GEM_PATH=/usr/local/bundle/ruby/3.4.0 \
    PATH=/usr/local/bundle/ruby/3.4.0/bin:/usr/local/bundle/bin:$PATH

WORKDIR /workspaces/all_in_one_rails

RUN gem update --system && gem install bundler

USER $USERNAME
