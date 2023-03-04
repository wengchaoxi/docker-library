# docker-library

A collection of docker library images.

## Template

```sh
├── .github/workflows
│   ├── ...
│   └── example.yml
├── ...
└── example
    ├── ...
    └── Dockerfile
```

### example.yml

```yaml
# See: https://github.com/wengchaoxi/docker-library

name: Build and push `example` docker image

on:
  workflow_dispatch:
  push:
    branches:
      - main
    paths:
      - example/**
      - .github/workflows/example.yml
  pull_request:
    branches:
      - main
    paths:
      - example/**
      - .github/workflows/example.yml

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: true

      - name: Set up qemu
        uses: docker/setup-qemu-action@v1

      - name: Set up docker buildx
        uses: docker/setup-buildx-action@v1

      - name: Login to docker hub
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Login to github package registry
        env:
          username: ${{ github.repository_owner }}
          # https://github.com/settings/tokens/new?scopes=write:packages
          password: ${{ secrets.GHCR_TOKEN }}
        run: echo ${{ env.password }} | docker login ghcr.io -u ${{ env.username }} --password-stdin

      - name: Build and push docker image
        uses: docker/build-push-action@v2
        with:
          file: example/Dockerfile
          platforms: linux/amd64
          context: example
          push: true
          tags: |
            wengchaoxi/example:latest
            ghcr.io/wengchaoxi/example:latest
```
