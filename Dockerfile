# Based on Debian:buster-slim
FROM --platform=linux/arm64 alpine

# Who's your Maintainer
LABEL maintainer="Shallowlovest@qq.com"

# COPY Base File
COPY entry.sh install_base.sh /

RUN sh install_base.sh

# ENTRYPOINT
CMD ["/entry.sh"]