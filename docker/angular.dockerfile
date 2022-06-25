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
