FROM cr.loongnix.cn/loongson/loongnix-server:8.3 as builder

WORKDIR /opt

ARG VERSION=v4.14.1
ENV VERSION=${VERSION}

RUN set -ex \
    && yum -y install loongnix-release-epel \
    && yum -y install nodejs python38 python38-devel python2 python2-devel gcc-c++ make git git-lfs which \
    && yum clean all \
    && rm -rf /var/cache/yum/*

RUN set -ex \
    && git clone -b ${VERSION} https://github.com/sass/node-sass

RUN set -ex \
    && cd /opt/node-sass \
    && npm install \
    && node scripts/build -f \
    && FILE=vendor/linux-*/binding.node \
    && FILE_NAME=$(echo ${FILE} | sed 's@vendor/@@g' | sed 's@/@_@g') \
    && mkdir dist \
    && cp vendor/linux-*/binding.node dist/${FILE_NAME} \
    && cd dist \
    && echo "$(sha256sum ${FILE_NAME} | awk '{print $1}') ${FILE_NAME}" > "${FILE_NAME}.txt"

VOLUME /dist

CMD cp -rf dist/* /dist/
