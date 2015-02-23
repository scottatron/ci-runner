FROM scottatron/ruby:2.1.5

ENV DEBIAN_FRONTEND noninteractive
RUN echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

# Prepare a known host file for non-interactive ssh connections
RUN mkdir -p /root/.ssh
RUN touch /root/.ssh/known_hosts

RUN apt-get clean && apt-get update -qqy
RUN apt-get install -qqy libicu-dev build-essential curl git docker.io

# Install the runner
RUN curl --silent -L https://gitlab.com/gitlab-org/gitlab-ci-runner/repository/archive.tar.gz | tar xz
RUN mv /gitlab-ci-runner.git /runner
WORKDIR /runner
RUN bundle install --deployment

# Install docker-compose
RUN curl -L https://github.com/docker/fig/releases/download/1.1.0-rc2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose; chmod +x /usr/local/bin/docker-compose

# Clean up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
