ARG jetbrainsTeamCityAgentImage='jetbrains/teamcity-agent:latest'

FROM ${jetbrainsTeamCityAgentImage}
LABEL maintainer="ormico"
LABEL Description="Dotnet Core; Powershell Core + SQL Svr Module; NVM; Node.js"

ENV NVM_DIR "$HOME/.nvm"
ENV NODE_VERSION 11.15.0

EXPOSE 9090

USER root

RUN apt-get update && \
    apt-get install -y \
        curl \
        wget \
        unzip \
    && curl -O https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb  \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && add-apt-repository universe \
    && apt-get install -y powershell \
        dotnet-sdk-2.2 \
        dotnet-sdk-2.1 \
        dotnet-sdk-3.1 \
    && pwsh -ExecutionPolicy unrestricted -c "Install-Module -Name SqlServer -Force" \
    && rm packages-microsoft-prod.deb \
    && mkdir $NVM_DIR \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
# after installing nvm the below are required to use node w/o restarting shell
RUN export NVM_DIR="$HOME/.nvm"
RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
RUN [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# install rimraf
RUN npm install -g rimraf

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && az aks install-cli

#USER buildagent
