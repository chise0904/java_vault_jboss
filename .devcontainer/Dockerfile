FROM maven:3.9-eclipse-temurin-17

# 安裝必要工具
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    jq \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 安裝 Node.js（Claude Code CLI 需要）
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# 安裝 Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

WORKDIR /workspaces
