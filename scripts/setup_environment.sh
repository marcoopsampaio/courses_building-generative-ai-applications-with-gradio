#!/bin/bash

# The requirements for the app can be found in pyproject.toml

# Use the null backend which acts as a placeholder and does not store passwords
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

set -e

# Check if running in the correct repo
PROJECT_ROOT=$(git rev-parse --show-toplevel)
if [ ! $(basename "$PROJECT_ROOT") == "courses_building-generative-ai-applications-with-gradio" ];
then
    echo "Running script inside wrong repo: $PROJECT_ROOT"
    echo "Please run this script inside the courses_building-generative-ai-applications-with-gradio repo"
    exit 1
fi

# Install pyenv
if ! command -v pyenv &> /dev/null; then
  echo "pyenv not found. Installing pyenv..."
  curl https://pyenv.run | bash
  # exit to force the user to run this script again
  echo "Please run this script again"
  exit 1
else
  echo "pyenv is already installed."
fi

# Install and set local Python version according to .python-version
PYTHON_VERSION=$(cat .python-version)

if [ "$(pyenv versions --bare | grep -w $PYTHON_VERSION)" == "" ]; then
    pyenv install $PYTHON_VERSION
fi

pyenv local $PYTHON_VERSION

# Read the poetry version from .poetry-version in the root directory
POETRY_VERSION=$(cat "$PROJECT_ROOT/.poetry-version")
# Install poetry
echo "Installing poetry..."
pip install poetry==$POETRY_VERSION

# Install dependencies
echo "Installing dependencies..."
poetry install

poetry run pre-commit install
