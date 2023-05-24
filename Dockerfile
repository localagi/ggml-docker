ARG FROM_IMAGE
FROM ${FROM_IMAGE}

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update ; \
    apt-get upgrade -y ; \
    apt-get install -y --no-install-recommends ninja-build build-essential cmake libopenblas-dev

COPY --link . /ggml
RUN mkdir /ggml/build
WORKDIR /ggml/build
ARG CMAKE_ARGS=
RUN cmake .. ${CMAKE_ARGS}
ARG GGML_MODELS="gpt-2 gpt-j"
RUN make -j4 ${GGML_MODELS}

WORKDIR /ggml/build/bin
ENV PATH="PATH=$PATH:/ggml/build/bin"
