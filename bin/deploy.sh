#!/bin/bash
if git diff-index --quiet HEAD --; then # Check to make sure there are no uncommited changes
    set -o errexit; # Exit on error
echo Step 1/1: Creating production build;
    npm run deploy:prod;
echo Step 2/2: Archiving previous production image;
    now=$(date +"%m_%d_%Y") # Tag and archive old docker latest. Push to dockerhub.
    docker tag ianlancaster/zen-production:latest ianlancaster/zen-production:$now;
    docker push ianlancaster/zen-production:$now;
echo Step 3/3: Creating new production image;
    mv Dockerfile.prod.off Dockerfile;
    docker build -t ianlancaster/zen-production . # Build a new latest docker image. Push to dockerhub.
    mv Dockerfile Dockerfile.prod.off;
    docker push ianlancaster/zen-production;
echo Step 4/4: Creating elastic beanstalk environment;
eb $1 zen-production # Create the elastic beanstalk environment.;
else
    echo Please commit your changes first.;
fi
