ARG PLATFORM
FROM dockcross/$PLATFORM

# java tools
RUN mkdir -p /usr/share/man/man1
RUN if [ -n "$(command -v yum)" ]; then \
        yum install -y ant java-1.7.0-openjdk-devel \
    ; fi
RUN if [ -n "$(command -v apt-get)" ]; then \
        apt-get update && apt-get install -y \
            ant openjdk-8-jdk \
        && rm -rf /var/lib/apt/lists/* \
    ; fi

# workaround for tools that are hardcoded
# to look for gcc/g++ instead of $CC/$CXX
RUN rm -f /usr/bin/gcc && \
    ln -s $CC /usr/bin/gcc
RUN rm -f /usr/bin/g++ && \
    ln -s $CXX /usr/bin/g++

ENTRYPOINT []
CMD ["/bin/bash"]
