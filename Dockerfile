FROM debian:buster-slim
LABEL maintainer="code@ongoing.today"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --fix-missing && \
    apt-get install -qqy --no-install-recommends \
    locales git pelican apt-transport-https ca-certificates python3-pip python3-setuptools python3-dev && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    update-ca-certificates && \
    python3 -m pip install wheel && \
    mkdir -p /home/attackuser && \
    cd /home/attackuser && \
    git clone --depth=1 --no-tags https://github.com/mitre-attack/attack-website.git && \
    cd /home/attackuser/attack-website && \
    rm -rf .git* && \
    sed -i -E "s/1000:/3000:/" modules/sizechecker.py && \
    python3 -m pip install -r requirements.txt && \
    cd /home/attackuser/attack-website && \
    python3 update-attack.py -c -b && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/attackuser/attack-website/output
CMD ["python3", "-m", "pelican.server", "80"]
EXPOSE 80
