

# helpful ldflags reference: https://www.digitalocean.com/community/tutorials/using-ldflags-to-set-version-information-for-go-applications


# --- run ---

FROM photon:3.0 as runimage

RUN tdnf install -y shadow-tools

RUN groupadd -g 2000 secretgen-controller && useradd -r -u 1000 --create-home -g secretgen-controller secretgen-controller
RUN chmod g+w /etc/pki/tls/certs/ca-bundle.crt && chgrp secretgen-controller /etc/pki/tls/certs/ca-bundle.crt
USER secretgen-controller

COPY controller secretgen-controller

ENV PATH="/:${PATH}"
ENTRYPOINT ["/secretgen-controller"]
