#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPOSITORY_OWNER=$1
REPOSITORY_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get_call {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function users_list_read_access {
    local endpoint="repos/${REPOSITORY_OWNER}/${REPOSITORY_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get_call "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPOSITORY_OWNER}/${REPOSITORY_NAME}."
    else
        echo "Users with read access to ${REPOSITORY_OWNER}/${REPOSITORY_NAME}:"
        echo "$collaborators"
    fi
}

# Main script

echo "Listing users with read access to ${REPOSITORY_OWNER}/${REPOSITORY_NAME}..."
users_list_read_access
