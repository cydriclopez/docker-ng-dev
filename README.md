
# docker-ng-dev

## Dockerize your Angular dev environment

> ***This tutorial requires some knowledge in Linux, Docker, Git, and Angular.***

### Why Angular?

I have gotten to like Angular for PWA app dev. In Angular to include the scaffolding code for a PWA project just takes [one command](https://web.dev/creating-pwa-with-angular-cli/). Here is [more info](https://angular.io/guide/service-worker-intro) on Angular PWA. Angular is a [Single Page App](https://en.wikipedia.org/wiki/Single-page_application) (SPA) web framework that has the semblance of the classic fat-client app but using web technology (HTML, JavaScript, & CSS).

Angular is a [Nodejs](https://nodejs.org/en/) project. Nodejs is required to run Angular for development. Installing and running Nodejs is made more convenient using Docker.

Node or Nodejs are often interchanged. Node.js is the project site where as Node is the software package for the JavaScript runtime built on Chrome's V8 JavaScript engine. There is now the [Deno project](https://deno.land/) for running JavaScript and TypeScript (natively with no transpiling).

In Angular code is written in [TypeScript](https://angular.io/guide/typescript-configuration#typescript-configuration) that is then transpiled into JavaScript for running in the browser.

The Angular compiler generates static files in the folder ***dist/project-name*** which when hosted in a web server is all that is needed to run the app in the browser. Data communication is via JSON API, WebSocket, or gRPC. Angular these days can also use [Server-side Rendering](https://angular.io/guide/universal).

This tutorial is mostly about 1.) creating the Angular docker image and, 2.) adding an alias command in the ***~/.bashrc*** file. It is a 2-step process that I stretched into 5 steps for clarity.

The steps outlined here are simpler than painstakingly manually [installing Node from here](https://github.com/nodejs/help/wiki/Installation), followed by [installing Angular from here](https://angular.io/guide/setup-local#install-the-angular-cli).

You can adapt these steps to use several versions of Nodejs for your different Nodejs/React/Angular projects.

### Docker intro

VMs and containers have been [around for a while](https://blog.aquasec.com/a-brief-history-of-containers-from-1970s-chroot-to-docker-2016). They predate [Docker](https://www.docker.com/). There are other Docker [alternative projects](https://www.containiq.com/post/docker-alternatives). Most are [OCI compliant](https://opencontainers.org/) projects.

Early on, [Linux](https://www.linuxfoundation.org/) got to have the foundational code pieces in namespace, cgroup, unionfs, and chroot to make VMs and containers possible. In Linux there is no need to use a VM to run Docker. [Docker Compose](https://docs.docker.com/compose/) is a tool for conveniently wiring together multi-container Docker applications using a YAML text file. [LXD](https://linuxcontainers.org/), [Kubernetes](https://kubernetes.io/), [Swarm](https://docs.docker.com/engine/swarm/), and etc. extend containers into nodes spanning multiple servers. This area in IT is a fast moving train that is quite fun to ride.

### Docker for deployment

Docker is an application deployment technology. With Docker you can choose a pre-built image then copy your application into this image, including all the codes, libraries and dependencies that your application needs. In Docker you script, using a Dockerfile, the build process of your application image. A container is the running instance of the docker image. Checkout the [Docker documentation](https://docs.docker.com/). It is quite comprehensive.

I recommend <ins>***using only Docker Official Images***</ins> to keep away from malicious codes and vulnerabilities. You can also use images from companies you trust.

The Docker official repository of images is located in [<ins>hub.docker.com</ins>](https://hub.docker.com/). Here you can search for the docker image you can download. This is the docker hub page for [Node](https://hub.docker.com/_/node). Node is the foundation code to run Angular.

### Docker for development

Docker is also an application development technology. These days it makes a lot of sense to install software dev tools into a Docker image. The nice thing about it is that when a new version of the tool comes out, you can just create an image of this new version.

**The key to using Docker in development is to bind mount your main project folder into a folder in the Docker image using the --volume or -v option. Once you have this mapping done then use the --workdir or -w option to declare this folder inside the Docker image as the working folder.**

For example is the following ***docker run*** command:
```bash
docker run -it --rm \
-p 4200:4200 -p 9876:9876 \
-v /home/$USER/Projects/ng:/home/node/ng \
-w /home/node/ng angular /bin/sh
```

Instead of typing the previous ***docker run*** command with all its parameters we will create an alias so we can just type ***angular*** to run the Angular docker image and make available the Angular ***ng*** command for development use.

### Dockerizing Angular steps

The way I prefer to use Docker for Angular development purposes is to keep the image lean. To make it work takes 5 steps:
1. Git clone this project, then type ***cd docker-ng-dev/docker***
2. Build the image using the Dockerfile ***angular.dockerfile***
3. Create your main Angular project folder with ***mkdir -p ~/Projects/ng***
4. Add an alias entry in your ~/.bashrc file as shown below
5. Reload your ~/.bashrc file with the command:   ***.   ~/.bashrc***

After step 5 you can run the alias command: ***angular***<br/>
You will now be in the Angular-Node container. To exit type ***exit***.

### The Dockerfile

The docker file ***docker/angular.dockerfile*** is fully commented.
```dockerfile
# angular.dockerfile
# Dockerize your Angular dev environment

# So you won't be typing "sudo docker" a lot, suggested
# Linux Docker post install commands:
# sudo groupadd docker
# sudo usermod -aG docker $USER

# 1. After git cloning this project type: cd docker-ng-dev/docker
# 2. Build the Angular image using the command:
# docker build -f angular.dockerfile -t angular .

# 3. Create your main Angular project working folder. This folder can
# be anywhere as long as it jives with the alias command in the next step.
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

---

### Some preliminaries for clarity

<ins>***Note that in the following command examples the colon ":" is part of my command-line prompt.</ins>
<br/>
<ins>You DO NOT type the colon ":" as part of the command.***</ins>
<br/>

Note that in Linux you can customize your command-line prompt. In my ***~/.bashrc*** file I have entered the following statement to customize my command-line prompt using the ***PS1*** environment variable.

```bash
export PS1=$PS1'\n:'
```

This statement in my ***~/.bashrc*** turns my command-line prompt into the following below. **This way no matter how long my current path is, my prompt starts at the leftmost part of my screen after the colon ":" character.**

```bash
user1@penguin:~/Projects/ng/my-app/node_modules/@angular/cli/src/commands/update/schematic$
:
```

So that you won't be typing ***sudo docker*** a lot, I suggest you run the following Linux Docker post install commands:

```
user1@penguin:~$
:sudo groupadd docker
:sudo usermod -aG docker $USER
```

You can also read on my humble <a href="https://github.com/cydriclopez/docker-pg-dev#my-laptop-setup">laptop setup</a>

Ok now that we have some clarity, let's get right to it. 😊

---

### 1. Git clone this project in a working folder

```
:git clone https://github.com/cydriclopez/docker-ng-dev.git
:cd docker-ng-dev/docker
```

### 2. Build the Angular image

Once inside the ***docker-ng-dev/docker*** folder build the Angular image using the command:

```
:docker build -f angular.dockerfile -t angular .
```

Note that there is a "dot" or a period "." at the end of this command. The period "." gives the current folder as context for the docker command. It tells ***docker build*** command where to find the docker file ***angular.dockerfile***. Without the "-f" it looks for the default ***Dockerfile*** file. The "-t" names the docker image so when we type the command ***docker images*** it lists the created image as "angular".
```
:docker images
REPOSITORY   TAG            IMAGE ID       CREATED        SIZE
angular      latest         809901e9120f   17 hours ago   170MB
postgres     latest         6a3c44872108   4 months ago   374MB
node         14.18-alpine   194cd0d85d8a   5 months ago   118MB
```
Note that the ***angular*** and ***node*** entries were added after the ***docker build*** command.

That ***postgres*** image entry is the subject of the next tutorial [***Dockerize your Postgresql dev environment***](https://github.com/cydriclopez/docker-pg-dev).


### 3. Create your main Angular project folder

Create your main Angular project working folder. This folder can be anywhere as long as it jives with the alias command in the next step. In this example the main Angular project folder is ***~/Projects/ng***
So we type:

```
:mkdir -p ~/Projects/ng
```
In this project folder you can have several subfolders to house your multiple Angular projects. This is a sample listing of projects in my Angular project folder.

```
:pwd
/home/user1/Projects/ng
:ll
drwxr-x--x 1 user1 user1   366 May 28 11:57 advert-primeng
drwxr-x--x 1 user1 user1   228 Dec 12  2021 go-post-json-passthru
drwxr-x--x 1 user1 user1   322 May 22 15:46 material-cart
drwxr-x--x 1 user1 user1   366 Jun 23 22:12 treemodule-json
drwxr-x--x 1 user1 user1   332 Aug 13  2021 ultima-try
```

### 4. Add an alias in ~/.bashrc by adding the following lines:

```bash
alias angular='docker run -it --rm \
-p 4200:4200 -p 9876:9876 \
-v /home/$USER/Projects/ng:/home/node/ng \
-w /home/node/ng angular /bin/sh'
```

This is a one-liner command that has been separated with the bash continuing character "\\" to make it easier to read.

The ***-it*** option keeps ***docker run*** interactive. The ***--rm*** option automatically removes the container when it exits. This means that when inside the Docker container command prompt terminal program ***/bin/sh***, typing ***exit*** ends the terminal session then Docker removes the running container from memory. The angular image remains on disk ready to run again but its running instance, which is the container, was effectively cleared from memory.

This alias that runs the ***docker run*** command has more parameters that can be clarified by the following table.

### Table 1. Your host pc to Docker mappings table
|    | Your host pc | Docker |
| ----------- | --- | ----------- |
| ng serve port (-p) | 4200 | 4200 |
| ng test port (-p) | 9876 | 9876 |
| volume folder mapping (-v) | /home/$USER/Projects/ng | /home/node/ng |
| working folder (-w) | (/home/$USER/Projects/ng) | /home/node/ng |
| repository name |    | angular |
| executable in the repository |    | /bin/sh |

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
<img src="assets/images/vscode_add_alias.png" width="650"/>

### 5. Save and reload your ~/.bashrc file

After you have inserted the alias command in your ***~/.bashrc*** file save it, and then reload it using the ***source ~/.bashrc*** command:

```
:source ~/.bashrc
```

Remember, as I mentioned before, the colon ":" is part of the command line prompt. You do not type it.

After your ***~/.bashrc*** reloads, then the command ***angular*** will be available. Try enter this ***angular*** command.

```
:angular
/home/node/ng #
```

Note that the command-line prompt has changed. This signifies that you have left your local host PC environment and you are now inside the Angular-Node Docker container. ***In Linux the hashtag or pound character prompt signifies you have root superpowers so be very careful. You have complete absolute control within that session. Mistakes can be damaging.*** You are in a virtual container session but you can affect the host system files.

Docker and other alternative systems have addressed this vulnerability by running the container in rootless mode.

### Create the Angular tutorial demo project application

At this point the alias command ***angular*** should now bring you inside the ***Angular-Node*** Docker container. Right here you can now follow the Angular tutorial and [create the example project](https://angular.io/guide/setup-local#create-a-workspace-and-initial-application).

After following the Angular example project you will then have a working demo app.

```bash
user1@penguin:~$
:angular
/home/node/ng # ng new my-app
...
[truncated Angular messages]
...
/home/node/ng # cd my-app
/home/node/ng/my-app # ng serve --host 0.0.0.0

✔ Browser application bundle generation complete.

Initial Chunk Files   | Names         |  Raw Size
vendor.js             | vendor        |   1.70 MB |
polyfills.js          | polyfills     | 296.95 kB |
styles.css, styles.js | styles        | 173.22 kB |
main.js               | main          |  47.66 kB |
runtime.js            | runtime       |   6.51 kB |

                      | Initial Total |   2.21 MB

Build at: 2022-06-26T17:37:24.470Z - Hash: 7944aecba1a9ca2a - Time: 6631ms

** Angular Live Development Server is listening on 0.0.0.0:4200, open your browser on http://localhost:4200/ **

✔ Compiled successfully.
```

The only exception here is that to serve your app use the command: ***ng serve --host 0.0.0.0***

Note that you add the ***--host 0.0.0.0*** parameter. This tells Angular to accept all incoming IP address. This is because your localhost PC has a different IP address than the Angular-Node Docker container. By default the Angular dev web server only allows connection from its own IP address.

## VERY IMPORTANT NOTE:

Code generated from inside the container will be owned by the root account which will make them read-only in your code editor. This can be corrected by running the ***sudo chown*** command:

```
:sudo chown -R $USER:$USER <generated-code-folder-name>
```

***chown*** is the "change of ownership" command in Linux.

This command will let you be the owner of the code generated from inside the Angular-Node Docker container. Thus making them editable in your editor.

### Chown command example

While the Angular demo app is running press ***Control-c*** to get you back into the command-line prompt.

```bash
...
[truncated Angular messages]
...
                      | Initial Total |   2.21 MB

Build at: 2022-06-26T17:37:24.470Z - Hash: 7944aecba1a9ca2a - Time: 6631ms

** Angular Live Development Server is listening on 0.0.0.0:4200, open your browser on http://localhost:4200/ **

✔ Compiled successfully.
^C/home/node/ng/my-app #
/home/node/ng/my-app #
```

The ***^C*** above shows where you have pressed ***Control-c*** to interrupt the running Angular demo app.

After you press ***Control-c*** to get you back into the command-line prompt, type ***exit*** to exit out of the Angular-Node Docker container as shown below.

Right at this point you are back into your host PC as signified be the prompt: ***user1@penguin:~$***

Then type ***cd ~/Projects/ng/my-app*** to go to the ***ng/my-app*** Angular generated demo app project folder.

Look at the ownership of the files below. They are all owned by the user:group ***root:root***. All of the files in this folder are read-only to you. You will not be able to modify them with your code editor.

```bash
/home/node/ng/my-app # exit
user1@penguin:~$
:cd ~/Projects/ng/my-app
user1@penguin:~/Projects/ng/my-app$
:pwd
/home/user1/Projects/ng/my-app
user1@penguin:~/Projects/ng/my-app$
:ll
total 376
-rw-r--r-- 1 root root   3039 Jun 24 17:24 angular.json
-rw-r--r-- 1 root root   1423 Jun 24 17:24 karma.conf.js
drwxr-xr-x 1 root root  14602 Jun 24 17:26 node_modules
-rw-r--r-- 1 root root   1069 Jun 24 17:24 package.json
-rw-r--r-- 1 root root 355383 Jun 24 17:25 package-lock.json
-rw-r--r-- 1 root root   1051 Jun 24 17:24 README.md
drwxr-xr-x 1 root root    156 Jun 24 17:24 src
-rw-r--r-- 1 root root    287 Jun 24 17:24 tsconfig.app.json
-rw-r--r-- 1 root root    863 Jun 24 17:24 tsconfig.json
-rw-r--r-- 1 root root    333 Jun 24 17:24 tsconfig.spec.json
user1@penguin:~/Projects/ng/my-app$
:
```

To change this situation you will have to go back one folder up by typing ***cd ..***

```bash
user1@penguin:~/Projects/ng/my-app$
:cd ..
user1@penguin:~/Projects/ng$
:pwd
/home/user1/Projects/ng
:ll
drwxr-x--x 1 user1 user1   366 May 28 11:57 advert-primeng
drwxr-x--x 1 user1 user1   228 Dec 12  2021 go-post-json-passthru
drwxr-x--x 1 user1 user1   322 May 22 15:46 material-cart
drwxr-x--x 1  root  root   358 Jun 24 17:26 my-app
drwxr-x--x 1 user1 user1   366 Jun 23 22:12 treemodule-json
drwxr-x--x 1 user1 user1   332 Aug 13  2021 ultima-try
```

Note that in the listing above our newly generated Angular demo app ***my-app*** is owned by the ***root*** account. The files in this folder will be read-only and cannot be altered using our code editor.

Right here we will enter the ***chown*** command as shown below. We prefix our command with ***sudo*** to momentarily give ourselves ***superuser*** permission **(sudo = "superuser do")** just for the life of the ***chown*** command. The ***-R*** option makes ***chown*** recurse thru all the sub-folders.

In Linux ***root*** ownership has the highest permission level so will require ***sudo*** to alter. You can only use ***sudo*** if you belong to the ***sudo*** group. By default the user account used to install Linux is made a member of the ***sudo*** group.

```bash
user1@penguin:~/Projects/ng$
:sudo chown -R $USER:$USER my-app
user1@penguin:~/Projects/ng$
:ll
drwxr-x--x 1 user1 user1   366 May 28 11:57 advert-primeng
drwxr-x--x 1 user1 user1   228 Dec 12  2021 go-post-json-passthru
drwxr-x--x 1 user1 user1   322 May 22 15:46 material-cart
drwxr-x--x 1 user1 user1   358 Jun 24 17:26 my-app
drwxr-x--x 1 user1 user1   366 Jun 23 22:12 treemodule-json
drwxr-x--x 1 user1 user1   332 Aug 13  2021 ultima-try
```

At this point all of the files in the Angular demo app ***my-app*** will be available for editing in our favorite code editor.

You will have to issue this command again, in your host PC main Angular project folder ***~/Projects/ng*** after you create components, services, or any code you generate from inside the Angular-Node Docker container.

For convenience you can use your terminal's reverse history search feature by pressing Control-r and typing ***chown*** and then repeatedly press Control-r again to look for the most appropriate ***chown*** command you typed before. Once you got it just modify the folder name then press enter. Control-c to start over.

Happy coding! 😊

---
