FROM golang:1.22-alpine3.19 as build

WORKDIR /azcopy
RUN apk add --no-cache build-base
RUN wget "https://github.com/Azure/azure-storage-azcopy/archive/v10.24.0.tar.gz" -O src.tgz
RUN tar xf src.tgz --strip 1 \
 && go build -o azcopy \
 && ./azcopy --version

FROM mcr.microsoft.com/azure-cli@sha256:f3c99192053c8993cfeeec073ce37ec09147bfce38acb41c8ab4183c5418132d as release

COPY --from=build /azcopy/azcopy /usr/local/bin

WORKDIR /templates
COPY . /templates
RUN chmod +x flatten-templates.sh
RUN /bin/bash flatten-templates.sh
RUN rm -rf flatten-templates.sh

CMD az storage blob sync -s "." -c templates \
 -d "${TAG:=$(cat /proc/sys/kernel/random/uuid)}/" \
 --connection-string $STORAGE_CONNECTION_STRING