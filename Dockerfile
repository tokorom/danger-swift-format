ARG SWIFT_VERSION=5.2
ARG DANGER_SWIFT_REVISION=master

FROM swift:${SWIFT_VERSION}

MAINTAINER tokorom

LABEL "com.github.actions.name"="Danger swift-format"
LABEL "com.github.actions.description"="Runs Dangerfiles with swift-format"
LABEL "com.github.actions.icon"="align-left"
LABEL "com.github.actions.color"="blue"

ENV DANGER_SWIFT_REVISION=${DANGER_SWIFT_REVISION}

# Install Danger-Swift
RUN git clone --depth=1 -b ${DANGER_SWIFT_REVISION} https://github.com/danger/danger-swift.git ~/danger-swift \
    && make -C ~/danger-swift install

# Install nodejs
RUN apt-get update -q \
    && apt-get install -qy curl \
    && mv /usr/lib/python2.7/site-packages /usr/lib/python2.7/dist-packages; ln -s dist-packages /usr/lib/python2.7/site-package \
    && curl -sL https://deb.nodesource.com/setup_10.x |  bash - \
    && apt-get install -qy nodejs \
    && rm -r /var/lib/apt/lists/*

# Install swift-format
RUN git clone -b swift-${SWIFT_VERSION}-branch https://github.com/apple/swift-format.git \
    && cd swift-format \
    && swift build

# Run Danger Swift via Danger JS, allowing for custom args
ENTRYPOINT ["npx", "--package", "danger", "danger-swift", "ci"]
