#!/usr/bin/env bash

# Helper function to get dynamic container name
get_container_name() {
    local service_name="${1:-litespeed}"

    # Try to get container name from docker compose ps
    local container_name=$(docker compose ps -q "${service_name}" 2>/dev/null | xargs -r docker inspect --format '{{.Name}}' 2>/dev/null | sed 's/^\///')

    if [ -n "${container_name}" ]; then
        echo "${container_name}"
        return 0
    fi

    # Fallback: search for running container with service label
    container_name=$(docker ps --filter "label=com.docker.compose.service=${service_name}" --format "{{.Names}}" | head -n 1)

    if [ -n "${container_name}" ]; then
        echo "${container_name}"
        return 0
    fi

    # Last fallback: use service name directly
    echo "${service_name}"
    return 1
}

# Export the function so it can be used by other scripts
export -f get_container_name
