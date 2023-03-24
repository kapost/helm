FROM amazon/aws-cli:latest

ENV VERIFY_CHECKSUM=false

# Install dependencies
RUN yum update && yum install -y \
    git \
    tar

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
