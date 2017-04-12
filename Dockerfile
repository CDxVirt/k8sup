FROM golang:1.7.5
MAINTAINER hsfeng@gmail.com

RUN apt-get -y update

RUN apt-get -y install net-tools jq iptables bc module-init-tools uuid-runtime ntpdate && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY cni-conf /go/cni-conf
COPY kube-conf /go/kube-conf
COPY dnssd /go/dnssd
COPY flannel-conf /go/flannel-conf

WORKDIR /go

RUN go get "github.com/grandcat/zeroconf" \
    && go build -o /go/dnssd/registering /go/dnssd/registering.go \
    && go build -o /go/dnssd/browsing /go/dnssd/browsing.go

ADD runcom /go/runcom
ADD kube-up /go/kube-up
ADD kube-down /go/kube-down
ADD entrypoint.sh /go/entrypoint.sh
ADD cp-certs.sh /go/cp-certs.sh
ADD kube-conf/abac_policy_file.jsonl /go/abac_policy_file.jsonl
ADD service-addons.sh /go/service-addons.sh

RUN chmod +x /go/entrypoint.sh
RUN chmod +x /go/kube-up

ENTRYPOINT ["/go/entrypoint.sh"]
CMD []
