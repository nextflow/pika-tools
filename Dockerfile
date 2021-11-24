FROM centos:7 as builder

ENV PIKA_TOOLS  /pika-tools
ENV PIKA_BUILD_DIR /tmp/pika-tools
ENV PATH ${PIKA_TOOLS}:${PATH}

COPY . ${PIKA_BUILD_DIR}
WORKDIR ${PIKA_BUILD_DIR}

RUN rpm -ivh https://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm && \
    yum clean all && \
    yum -y makecache && \
    yum -y install snappy-devel && \
    yum -y install protobuf-devel && \
    yum -y install gflags-devel && \
    yum -y install glog-devel && \
    yum -y install bzip2-devel && \
    yum -y install zlib-devel && \
    yum -y install lz4-devel && \
    yum -y install libzstd-devel && \
    yum -y install gcc-c++ && \
    yum -y install make && \
    yum -y install which && \
    yum -y install git && \
    yum -y install sudo && \
    sh ./pika-port/build3.sh && \
    cp ${PIKA_BUILD_DIR}/pika-tools/pika-port/pika_port_3/pika_port ${PIKA_TOOLS} && \
    yum -y remove gcc-c++ && \
    yum -y remove make && \
    yum -y remove which && \
    yum -y remove git && \
    yum -y clean all 

FROM centos:7
ENV PIKA_TOOLS  /pika-tools
ENV PATH ${PIKA_TOOLS}:${PATH}

RUN set -eux; yum install -y epel-release; \
 yum install -y snappy protobuf gflags glog bzip2 zlib lz4 libzstd rsync; \
 yum clean all;

WORKDIR ${PIKA_TOOLS}
COPY --from=builder $PIKA_TOOLS ./
CMD ["pika-port"]