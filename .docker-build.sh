#!/bin/sh

docker pull $TRAVIS_REPO_SLUG:dev || true
docker build \
	--cache-from $TRAVIS_REPO_SLUG:dev \
	--build-arg compiler=$OCAML_VERSION \
	--build-arg packages="$PACKAGES" \
	--build-arg pins="$PINS" \
	--target dev \
	-t $TRAVIS_REPO_SLUG:dev .
[ $TRAVIS_PULL_REQUEST != false ] || docker push $TRAVIS_REPO_SLUG:dev


if [ -z "$DEPLOY_REGISTRY" ]; then
	echo No deployment registry specified in DEPLOY_REGISTRY... done.
	exit
fi

TRAVIS_TAG=`git rev-parse --short $TRAVIS_COMMIT`
DEPLOY_TAG=$DEPLOY_REGISTRY/$DEPLOY_REPO:$TRAVIS_TAG
docker build \
	--cache-from $TRAVIS_REPO_SLUG:dev \
	--build-arg compiler=$OCAML_VERSION \
	--build-arg packages="$PACKAGES" \
	--build-arg pins="$PINS" \
	-t $DEPLOY_TAG .
[ $TRAVIS_PULL_REQUEST != false ] || docker push $DEPLOY_TAG
