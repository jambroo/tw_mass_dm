FROM frolvlad/alpine-oraclejdk8

RUN apk --update add bash ruby libc-dev make gcc ruby-dev

RUN gem install --no-ri --no-rdoc twurl json
