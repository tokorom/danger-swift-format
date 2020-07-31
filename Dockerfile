ARG SWIFT_VERSION=5.2
FROM swift:${SWIFT_VERSION}

ARG DANGER_SWIFT_REVISION=3.3.2
ARG SWIFT_FORMAT_REVISION=swift-5.2-branch

MAINTAINER tokorom

LABEL "com.github.actions.name"="Danger swift-format"
LABEL "com.github.actions.description"="Runs Dangerfiles with swift-format"
LABEL "com.github.actions.icon"="align-left"
LABEL "com.github.actions.color"="blue"

# Install nodejs
RUN apt-get update -q \
    && apt-get install -qy curl \
    && mv /usr/lib/python2.7/site-packages /usr/lib/python2.7/dist-packages; ln -s dist-packages /usr/lib/python2.7/site-package \
    && curl -sL https://deb.nodesource.com/setup_10.x |  bash - \
    && apt-get install -qy nodejs \
    && rm -r /var/lib/apt/lists/*

# Install Danger-Swift
RUN git clone --depth=1 -b ${DANGER_SWIFT_REVISION} https://github.com/danger/danger-swift.git _danger-swift \
    && cd _danger-swift \
    && make install

# Install danger-js
RUN npm install -g danger

# Install swift-format
RUN git clone -b ${SWIFT_FORMAT_REVISION} https://github.com/apple/swift-format.git _swift-format \
    && cd _swift-format \
    && swift build -c release \
    && ln -s .build/release/swift-format /usr/local/bin/swift-format 

# Run Danger Swift via Danger JS, allowing for custom args
ENTRYPOINT ["danger-swift", "ci"]
