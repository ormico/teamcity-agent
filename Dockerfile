ARG jetbrainsTeamCityAgentImage='jetbrains/teamcity-agent:latest'

FROM ${jetbrainsTeamCityAgentImage}
#FROM jetbrains/teamcity-agent:latest

LABEL maintainer="ormico"
LABEL Description="Dotnet Core; Powershell Core + SQL Svr Module; NVM; Node.js; Chrome + Selenium driver"
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

# test if node is working and install rimraf
RUN node -v \
    && npm -v \
    && npm install -g rimraf

RUN curl -O https://dl-ssl.google.com/linux/linux_signing_key.pub \
    && apt-key add linux_signing_key.pub \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update -y \
    && apt-get -y install \
        google-chrome-stable \
    && rm /etc/apt/sources.list.d/google-chrome.list \
    && rimraf /var/lib/apt/lists/* /var/cache/apt/*

RUN CD_VER=$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE) \
  && echo "chromedriver v: "$CD_VER \
  && curl -s -o /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CD_VER/chromedriver_linux64.zip \  
  && rimraf /opt/selenium/chromedriver \
  && unzip /tmp/chromedriver_linux64.zip -d /opt/selenium \
  && rm /tmp/chromedriver_linux64.zip \
  && mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CD_VER \
  && chmod 755 /opt/selenium/chromedriver-$CD_VER \
  && ln -fs /opt/selenium/chromedriver-$CD_VER /usr/bin/chromedriver

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash \
    && az aks install-cli

USER buildagent
