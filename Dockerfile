# App production diagram
  # Pic: https://drive.google.com/open?id=163YOu59sq6zximxxV_8KM260YJcrUxsq
  # Class: https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/learn/lecture/11437092#overview

FROM node:alpine as build-phase

# When you specifying a working directory, you'll enter directly into the "/app" foler when you entering that container through shell command
# Try command: $ docker exec -it ${DOCKER_IMAGE_ID} sh

# The benefit of "COPY package.json ." first rather than just "COPY . ." directly is
# using the cache of node_module dependencies from previoud build steps.
# See: https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/learn/lecture/11436964#overview

# In statement "COPY . ."
# the first argument is the path to folder on your machine relative to "build context"
# which is the context specified when you run "$ docker build ."
# See: https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/learn/lecture/11436956#overview

WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Production architecture for single container: https://drive.google.com/open?id=1DaWPEK13Qlew7A98YkEM-Khf5ohAlKHt

# By simply putting an another "From" statement that essentially says:
# Ok, the previous block all complete, don't worry about it.
# See: https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/learn/lecture/11437096#overview
FROM nginx
# AWS EBS will look at this EXPOSE instruction to do port mapping to port 80 (EBS using 80 as default port)
EXPOSE 80
# In production mode, we make Nginx host all the React production files. And then start it up on EBS.
COPY --from=build-phase /app/build /usr/share/nginx/html

# For statement "COPY --from=build-phase" means we want to copy something from that other phase

# The default command of the Nginx container/ image is going to start up Nginx for us
# So we don't have to actually specifically add any running statement
