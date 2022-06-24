# angular.dockerfile
# Dockerize your Angular dev environment

# 1.)
# Create angular image using the command:
# docker build -f angular.dockerfile -t angular .

# 2.)
# Create your main Angular project working folder.
# You can create project sub-folders in this Angular project folder.
# mkdir -p ~/Projects/ng

# 3.)
# Add an alias in ~/.bashrc by adding the lines (remove #):
# alias angular='docker run -it --rm \
# -p 4200:4200 -p 9876:9876 \
# -v /home/user1/Projects/ng:/home/node/ng \
# -w /home/node/ng angular /bin/sh'

# 4.)
# Then reload ~/.bashrc by entering command:
# . ~/.bashrc

FROM node:14.18-alpine
RUN npm install -g @angular/cli
