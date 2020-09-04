FROM swift:5.2

ARG DANGER_SWIFT_REPOSITORY="https://github.com/tokorom/danger-swift.git"
ARG DANGER_SWIFT_BRANCH="with-danger-swift-format/3.4.1"

ARG SWIFT_FORMAT_REPOSITORY="https://github.com/apple/swift-format.git"
ARG SWIFT_FORMAT_BRANCH="swift-5.2-branch"

LABEL repository "https://github.com/tokorom/danger-swift-format"
LABEL homepage "https://github.com/tokorom/danger-swift-format"
LABEL maintainer "tokorom <tokorom@gmail.com>"

# Install nodejs
RUN apt-get update -q \
    && apt-get install -qy curl \
    && mv /usr/lib/python2.7/site-packages /usr/lib/python2.7/dist-packages; ln -s dist-packages /usr/lib/python2.7/site-package \
    && curl -sL https://deb.nodesource.com/setup_10.x |  bash - \
    && apt-get install -qy nodejs \
    && rm -r /var/lib/apt/lists/*

# Install danger-swift
RUN git clone --depth=1 -b $DANGER_SWIFT_BRANCH $DANGER_SWIFT_REPOSITORY _danger-swift \
    && cd _danger-swift \
    && make install \
    && cd

# Install Danger-JS(Danger-Swift depends)
RUN npm install -g danger

# Install swift-format
RUN git clone -b  $SWIFT_FORMAT_BRANCH $SWIFT_FORMAT_REPOSITORY _swift-format \
    && cd _swift-format \
    && swift build -c release \
    && ln .build/release/swift-format /usr/local/bin/swift-format \
    && cd

ADD entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT [ "entrypoint" ]
CMD [ "ci" ]
