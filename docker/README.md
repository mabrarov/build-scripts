# Builder Docker Images

Docker images building 3rd-party libraries.

Assumptions for Docker images utilizing Windows Containers:

1. [Docker](https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/deploy-containers-on-server) runs on [Windows Server 2022 LTSC](https://docs.microsoft.com/en-us/windows-server/get-started/windows-server-release-info)
1. Docker 20.10+
1. Commands in README files use Bash (Git Bash) syntax, unless different is explicitly specified
1. Commands in README files assume current directory is the directory where this repository is cloned
