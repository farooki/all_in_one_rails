FROM ruby:3.4.6-bookworm

ARG NODE_MAJOR=20

# Install system dependencies and Node.js
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      git \
      gnupg2 \
      libsqlite3-dev \
      libvips \
      libyaml-dev \
      pkg-config \
      sqlite3 && \
    curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Create non-root user to match VS Code convention
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID --create-home --shell /bin/bash $USERNAME

WORKDIR /workspaces/all_in_one_rails

RUN gem update --system && gem install bundler

USER $USERNAME
