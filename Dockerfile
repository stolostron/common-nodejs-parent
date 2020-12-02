FROM registry.redhat.com/ubi8/ubi-minimal:latest

ENV NODEJS_VERSION=12
COPY install-npm.sh install-npm.sh

# To install nodejs:12 on ubi-minimal, we need to enable the module... which
# is only possible through dnf. Instead of going through dnf, we can use
# modularity in libdnf: https://fedoramagazine.org/building-smaller-container-images
# We only want to install nodejs, so uninstall the rest

# If you are using this parent image and want to install npm, you can use the included
# script to install npm and uninstall the other packages that come with it, i.e
#
# RUN ./install-npm.sh

RUN echo -e "[nodejs]\nname=nodejs\nstream=${NODEJS_VERSION}\nprofiles=\nstate=enabled\n" > /etc/dnf/modules.d/nodejs.module
RUN microdnf install nodejs && microdnf remove nodejs-full-i18n npm nodejs-docs && microdnf clean all
