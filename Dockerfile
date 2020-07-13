FROM ubuntu:19.10
LABEL maintainer="code@ongoing.today"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --fix-missing && \
    apt-get install -qqy --no-install-recommends \
    locales nano sudo git pelican apt-transport-https ca-certificates python3-pip python3-setuptools && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    update-ca-certificates && \
    python3 -m pip install wheel && \
    mkdir -p /home/attackuser && \
    cd /home/attackuser && \
    git clone https://github.com/mitre-attack/attack-website.git && \
    cd /home/attackuser/attack-website && \
    sed -i -E "s/1000:/3000:/" modules/sizechecker.py && \
    python3 -m pip install -r requirements.txt && \
    cd /home/attackuser/attack-website && \
    python3 update-attack.py -c -b

WORKDIR /home/attackuser/attack-website/output
CMD ["python3", "-m", "pelican.server", "80"]
EXPOSE 80
