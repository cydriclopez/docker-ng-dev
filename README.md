
# docker-ng-dev

## Dockerize your Angular dev environment

VMs and containers have been [around for a while](https://blog.aquasec.com/a-brief-history-of-containers-from-1970s-chroot-to-docker-2016). They predate [Docker](https://www.docker.com/). There are other Docker [alternative projects](https://www.containiq.com/post/docker-alternatives). Most are [OCI compliant](https://opencontainers.org/) projects.

Early on, [Linux](https://www.linuxfoundation.org/) got to have the foundational code pieces in namespace, cgroup, unionfs, and chroot to make VMs and containers possible. In Linux there is no need to use a VM to run Docker. [Docker Compose](https://docs.docker.com/compose/) is a tool for conveniently wiring together multi-container Docker applications using a YAML text file. [LXD](https://linuxcontainers.org/), [Kubernetes](https://kubernetes.io/), [Swarm](https://docs.docker.com/engine/swarm/), and etc. extend containers into nodes spanning multiple servers. This area in IT is a fast moving train that is quite fun to ride.

Docker is an application deployment technology. With Docker you can choose a pre-built image then copy your application into this image, including all the codes, libraries and dependencies that your application needs. In Docker you script, using a Dockerfile, the build process of your application image. A container is the running instance of the docker image. Checkout the [Docker documentation](https://docs.docker.com/). It is quite comprehensive.

I recommend <ins>***using only Docker Official Images***</ins> to keep away from malicious codes and vulnerabilities. You can also use images from companies you trust.

Docker is also an application development technology. These days it makes a lot of sense to install software dev tools into a Docker image. The nice thing about it is that when a new version of the tool comes out, you can just create an image of this new version.

The key to using Docker in development is to bind mount your main project folder into a folder in the Docker image using the --volume or -v option. Once you have this mapping done then use the --workdir or -w option to declare this folder inside the Docker image as the working folder.

It is now recommended to use the --mount option to mount local host folders into a Docker container but I find it requiring more parameters. The --volume or -v option is just simpler. In the official documentation it says that there is [no plan to deprecate](https://docs.docker.com/engine/reference/commandline/run/#add-bind-mounts-or-volumes-using-the---mount-flag) --volume or -v option.

The way I prefer to use Docker for development purposes is to keep the image lean. To make it work takes 5 steps:
1. Git clone this project, then type ***cd docker-ng-dev/docker***
2. Build the image using the Dockerfile ***angular.dockerfile***
3. Create your main Angular project folder with ***mkdir -p ~/Projects/ng***
4. Add an alias entry in your ~/.bashrc file as shown below
5. Reload your ~/.bashrc file with the command:   ***.   ~/.bashrc***

After step 5 you can run the alias command: ***angular***<br/>
You will now be in the Angular-Node container. To exit type ***exit***.

The docker file ***docker/angular.dockerfile*** is fully commented.
```dockerfile
# angular.dockerfile
# Dockerize your Angular dev environment

# 1. After git cloning this project type: cd docker-ng-dev/docker
# 2. Build the Angular image using the command:
# docker build -f angular.dockerfile -t angular .

# 3. Create your main Angular project working folder.
# You can create project sub-folders in this Angular project folder.
# mkdir -p ~/Projects/ng

# 4. Add an alias in ~/.bashrc by adding the lines (remove #):
# alias angular='docker run -it --rm \
# -p 4200:4200 -p 9876:9876 \
# -v /home/$USER/Projects/ng:/home/node/ng \
# -w /home/node/ng angular /bin/sh'

# 5. Then reload ~/.bashrc by entering command: . ~/.bashrc

# After step 5 you can then run the alias command: angular
# You will now be in the Angular-Node container. To exit type: exit

# IMPORTANT NOTE:
# Code generated from inside the container will be owned by the root
# account which will make them read-only from your code editor. This
# can be corrected by running the command:
#
# sudo chown -R $USER:$USER <generated-code-folder-name>
#
# This command will let you be the owner of the code generated from inside
# the Angular-Node Docker container. Thus making them editable in your editor.

FROM node:14.18-alpine
RUN npm install -g @angular/cli

```
<ins>***Note that in the following command examples the colon ":" is part of my command prompt.</ins>
<br/>
<ins>You DO NOT type the colon ":" as part of the command.***</ins>
<br/>
### 1. Git clone this project in a working folder
```
:git clone https://github.com/cydriclopez/docker-ng-dev.git
```

Or you can download and expand the [zip file](https://github.com/cydriclopez/docker-ng-dev/archive/refs/heads/main.zip). Then enter the command:
```
:cd docker-ng-dev/docker
```

### 2. Build the Angular image

Once inside the ***docker-ng-dev/docker*** folder build the Angular image using the command:
```
:docker build -f angular.dockerfile -t angular .
```

Note that there is a "dot" or a period "." at the end of this command. The period "." gives the current folder as context for the docker command. It tells docker where to find the docker file ***angular.dockerfile***. Without the "-f" it looks for the default ***Dockerfile*** file. The "-t" names the docker image. So when we type the command "docker images" it lists the created image as "angular".
```
:docker images
REPOSITORY   TAG            IMAGE ID       CREATED        SIZE
angular      latest         809901e9120f   17 hours ago   170MB
postgres     latest         6a3c44872108   4 months ago   374MB
node         14.18-alpine   194cd0d85d8a   5 months ago   118MB
```
Note that the ***angular*** and ***node*** entries were added after the ***docker build*** command.

That ***postgres*** image entry is the subject of the next tutorial ***Dockerizing your Postgresql dev environment***.


### 3. Create your main Angular project folder

In this example the main Angular project folder is ***~/Projects/ng***
So we type:
```
:mkdir -p ~/Projects/ng
```
In this project folder you can have several subfolders to house your multiple Angular projects. This is a sample listing of projects in my Angular project folder.
```
:pwd
/home/user1/Projects/ng
:ll
drwxr-xr-x 1 user1 user1   366 May 28 11:57 advert-primeng
drwx--x--x 1 user1 user1   228 Dec 12  2021 go-post-json-passthru
drwx--x--x 1 user1 user1   322 May 22 15:46 material-cart
drwxr-xr-x 1 user1 user1   366 Jun 23 22:12 treemodule-json
drwx--x--x 1 user1 user1   332 Aug 13  2021 ultima-try
```
### 4. Add an alias in ~/.bashrc by adding the following lines:
```bash
alias angular='docker run -it --rm \
-p 4200:4200 -p 9876:9876 \
-v /home/$USER/Projects/ng:/home/node/ng \
-w /home/node/ng angular /bin/sh'
```
This is a one-liner command that has been separated with the bash continuing character "\\" to make it easier to read. This alias command, with its parameters, can be clarified by the following table.

### Table 1. Your host pc to Docker mappings table
|    | Your host pc | Docker |
| ----------- | --- | ----------- |
| ng serve port ( -p ) | 4200 | 4200 |
| ng test port ( -p ) | 9876 | 9876 |
| volume folder mapping ( -v ) | /home/$USER/Projects/ng | /home/node/ng |
| working folder ( -w ) | ( /home/$USER/Projects/ng ) | /home/node/ng |
| repository name |    | angular |
| executable in the repository |    | /bin/sh |

The ***-it*** option keeps ***docker run*** interactive. The ***--rm*** option automatically removes the container when it exits. This means that when inside the Docker container command prompt terminal ***/bin/sh***, typing ***exit*** ends the terminal session then Docker removes the running container from memory. The angular image remains on disk ready to run again but its running instance which is the container was effectively cleared from memory.

### Use your editor to add the alias command "angular"
Use your code editor to edit your ***~/.bashrc*** file. In my case I enter the command:
```
:code ~/.bashrc
```
Then proceed to cut-and-paste the following lines into your editor:
```bash
alias angular='docker run -it --rm \
-p 4200:4200 -p 9876:9876 \
-v /home/$USER/Projects/ng:/home/node/ng \
-w /home/node/ng angular /bin/sh'
```
This is how it looks like in my code editor:<br/>
<img src="assets/images/vscode_add_alias.png" width="550"/>

### 5. Save and reload your ~/.bashrc file

After you have inserted the alias command in your ***~/.bashrc*** file save it, and then reload it using the command:
```
:. ~/.bashrc
```
This command starts with a period "." followed by a space then ***~/bashrc***

Remember, as I mentioned before, the colon ":" is part of the command line prompt. You do not type it.

After your ***~/.bashrc*** reloads, then the command ***angular*** will be available. Try enter this ***angular*** command.
```
:angular
/home/node/ng #
```
Note that the command-line prompt has changed. This signifies that you have left your localhost PC environment and you are now inside the Angular-Node Docker container. ***In Linux the hashtag or pound character prompt signifies you have root superpowers so be very careful. You have complete absolute control within that session. Mistakes can be damaging.*** You are in a virtual container session but you can affect the host system files.

Docker and other alternative systems have addressed this vulnerability by running the container in rootless mode.

At this point the alias command ***angular*** should now bring you inside the ***Angular-Node*** Docker container. Right here you can now follow the Angular tutorial and [create the example project](https://angular.io/guide/setup-local#create-a-workspace-and-initial-application).

After following the Angular example project you will then have a working demo app.
```
:angular
/home/node/ng # ng new my-app
[truncated Angular messages]
/home/node/ng # cd my-app
/home/node/ng/my-app # ng serve --host 0.0.0.0
```
The only exception is that to serve your app use the command: ***ng serve --host 0.0.0.0***

Note that you add the ***--host 0.0.0.0*** parameter. This tells Angular to accept all incoming IP address. This is because your localhost PC has a different IP address than the Angular-Node Docker container. By default the Angular dev web server only allows connection from its own IP address.

## IMPORTANT NOTE:

Code generated from inside the container will be owned by the root account which will make them read-only from your code editor. This can be corrected by running the command:
```
:sudo chown -R $USER:$USER <generated-code-folder-name>
```
This command will let you be the owner of the code generated from inside the Angular-Node Docker container. Thus making them editable in your editor. You will have to issue this command for every component, service, or any code created from inside the Docker container.

For convenience you can use your terminal's reverse history search feature by pressing Control-r and typing ***chown*** and then repeatedly press Control-r again to look for the most appropriate ***chown*** command you typed before. Once you got it just modify the folder name then press enter. Control-c to start over.

---
