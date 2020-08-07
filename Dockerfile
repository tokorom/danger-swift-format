FROM swift:5.2

MAINTAINER tokorom

LABEL "com.github.actions.name"="Danger Swift with swift-format"
LABEL "com.github.actions.description"="Runs Swift Dangerfiles with swift-format"
LABEL "com.github.actions.icon"="zap"
LABEL "com.github.actions.color"="blue"

# Install nodejs
RUN apt-get update -q \
    && apt-get install -qy curl \
    && mv /usr/lib/python2.7/site-packages /usr/lib/python2.7/dist-packages; ln -s dist-packages /usr/lib/python2.7/site-package \
    && curl -sL https://deb.nodesource.com/setup_10.x |  bash - \
    && apt-get install -qy nodejs \
    && rm -r /var/lib/apt/lists/*

# Install danger-swift
RUN git clone --depth=1 -b swift-format https://github.com/tokorom/danger-swift.git _danger-swift \
    && cd _danger-swift \
    && make install \
    && cd

# Install Danger-JS(Danger-Swift depends)
RUN npm install -g danger

# Install swift-format
RUN git clone -b swift-5.2-branch https://github.com/apple/swift-format.git _swift-format \
    && cd _swift-format \
    && swift build -c release \
    && ln .build/release/swift-format /usr/local/bin/swift-format \
    && cd

ADD entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT [ "entrypoint" ]
CMD [ "ci" ]
