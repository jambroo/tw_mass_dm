FROM frolvlad/alpine-oraclejdk8

RUN apk --update add bash ruby jq

RUN gem install --no-ri --no-rdoc twurl
