FROM oraclelinux:7-slim

RUN yum -y install oraclelinux-developer-release-el7 oracleinstantclient-release-el7 
RUN yum -y install python3 \
                   python3-libs \
                   python3-pip \
                   python3-setuptools \
                   python-cx_Oracle && \
    rm -rf /var/cache/yum/*

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
#...
# docker build . -f ol7.Dockerfile -t ol7:py-cx