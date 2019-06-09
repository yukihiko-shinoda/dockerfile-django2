FROM amazonlinux:2.0.20190508
WORKDIR /app
# ↓dependency on Pyenv, wait-for-it
RUN yum install -y git
RUN git clone git://github.com/pyenv/pyenv.git /opt/pyenv
COPY ./pyenv.sh /etc/profile.d/pyenv.sh
# ↓dependency on Pyenv
RUN yum install -y patch gcc readline-devel zlib-devel bzip2 bzip2-devel sqlite sqlite-devel openssl-devel tar make
# ↓dependency on Pyenv Python 3.7
RUN yum install -y libffi-devel
ENV PYENV_ROOT /opt/pyenv
ENV PATH $PYENV_ROOT/bin:$PATH
RUN eval "$(pyenv init -)"
RUN pyenv install 3.7.3
RUN pyenv global 3.7.3
ENV PATH $PYENV_ROOT/shims:$PATH
# ↓dependency on Pipenv
RUN yum install -y which
RUN pip install pipenv
ENV LANG ja_JP.UTF-8
# ↓ @see http://docs.docker.jp/compose/startup-order.html
RUN git clone https://github.com/vishnubob/wait-for-it.git /usr/bin/wait-for-it
# ↓ install Node.js
RUN curl -sL https://rpm.nodesource.com/setup_11.x | bash -
ENTRYPOINT ["/usr/bin/wait-for-it/wait-for-it.sh"]
CMD [ "database:3306", "--", "python",  "manage.py", "runserver", "0.0.0.0:80" ]