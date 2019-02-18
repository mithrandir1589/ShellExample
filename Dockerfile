from alpine:3.9
RUN mkdir /updateEntitiesLog
COPY ./updateEntities.sh /etc/init.d
COPY ./ReadFile /etc/init.d
RUN apk update
RUN apk upgrade
RUN apk add bash
RUN apk add --update coreutils && rm -rf /var/cache/apk/*
RUn apk add curl