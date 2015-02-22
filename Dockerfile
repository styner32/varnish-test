FROM ubuntu:trusty

RUN apt-get update && apt-get install -qy software-properties-common apt-transport-https curl &&\
    apt-add-repository -y ppa:nginx/stable &&\
    apt-add-repository -y ppa:brightbox/ruby-ng &&\
    echo "deb https://repo.varnish-cache.org/ubuntu/ precise varnish-4.0" >> /etc/apt/sources.list.d/varnish-cache.list &&\
    curl https://repo.varnish-cache.org/GPG-key.txt | apt-key add - &&\
    apt-get update &&\
    apt-get install -qy git git-core nginx-extras nodejs libmysqlclient-dev libsqlite3-dev build-essential ruby2.2 ruby2.2-dev varnish ssh-import-id zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev supervisor openssh-server &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp
ADD . /opt/varnish-test/current/
ADD docker/run /usr/local/bin/run

RUN cd /opt/varnish-test/current/ &&\
    gem install bundler --no-ri --no-rdoc &&\
    bundle install --without development test -j 4 &&\
    ssh-import-id gh:styner32 &&\
    chmod -R 0600 /root/.ssh && chown -R root:root /root/.ssh /tmp &&\
    chmod 700 /usr/local/bin/run &&\
    mkdir -p /opt/varnish-test/current/tmp/pids &&\
    mkdir /var/run/sshd &&\
    chmod 0755 /var/run/sshd

EXPOSE 22 80 443
CMD ["/usr/local/bin/run"]