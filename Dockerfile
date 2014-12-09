FROM scottatron/ruby:2.1.5

ENV DEBIAN_FRONTEND noninteractive
RUN echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

# Prepare a known host file for non-interactive ssh connections
RUN mkdir -p /root/.ssh
RUN touch /root/.ssh/known_hosts

# Install the runner
RUN apt-get install -qqy libicu-dev build-essential
RUN apt-get install -qqy curl
RUN curl --silent -L https://gitlab.com/gitlab-org/gitlab-ci-runner/repository/archive.tar.gz | tar xz
RUN mv /gitlab-ci-runner.git /runner

WORKDIR /runner
RUN bundle install --deployment
RUN apt-get remove -qqy build-essential
RUN apt-get install -qqy git

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
