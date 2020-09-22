# Expanded TeamCity Linux Agent Docker Image
Everything the [JetBrains TeamCity Linux Agent](https://hub.docker.com/r/jetbrains/teamcity-agent) Base image has plus...
* [NVM](https://github.com/nvm-sh/nvm)
* [NodeJs](https://nodejs.org/en/) 11.15.0 but you can switch to any version with NVM
* [Powershell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7)
    * [SqlServer Module](https://docs.microsoft.com/en-us/sql/powershell/download-sql-server-ps-module?view=sql-server-ver15)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [.NET Core SDK](https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu)
   * 2.1
   * 2.2
   * 3.1
* [curl](https://curl.haxx.se/)

# How to use
Use this image exactly the same way you would use the [JetBrains TeamCity Linux Agent](https://hub.docker.com/r/jetbrains/teamcity-agent) image. 

# Docker Hub
[ormico/teamcity-agent](https://hub.docker.com/r/ormico/teamcity-agent)

# GitHub
[https://github.com/ormico/teamcity-agent](https://github.com/ormico/teamcity-agent)
