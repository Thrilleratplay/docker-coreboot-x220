#!/bin/bash
IMAGE_NAME="coreboot-builder-image"
CONTAINER_NAME="coreboot-builder"

# Build image if needed
IMAGE_EXISTS=$(docker images -q $IMAGE_NAME)
if [ $? -ne 0 ]; then
	echo "docker command not found"
	exit $?
elif [[ -z $IMAGE_EXISTS ]]; then
	echo "Building Docker image $IMAGE_NAME..."
	docker build --no-cache --rm -t "$IMAGE_NAME" ./
fi

# With the given name $CONTAINER_NAME, reconnect to running container, start
# an existing/stopped container or run a new one if one does not exist.
IS_RUNNING=$(docker inspect -f '{{.State.Running}}' $CONTAINER_NAME 2>/dev/null)
if [[ $IS_RUNNING == "true" ]]; then
	docker attach $CONTAINER_NAME
elif [[ $IS_RUNNING == "false" ]]; then
	docker start $CONTAINER_NAME
else
	docker run \
		   -v $(pwd)/build:/root/build \
		   --name $CONTAINER_NAME $IMAGE_NAME
fi

exit $?
