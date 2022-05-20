FROM python:3.8

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable

RUN apt-get install -y jq
RUN apt-get install -y parallel
RUN apt-get install -y git
RUN apt-get install -yqq unzip
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/
ENV DISPLAY=:99


COPY private_key /private_key
RUN chmod 600 /private_key
ENV GIT_SSH_COMMAND "ssh -i /private_key"
RUN mkdir /root/.ssh/ \
 && touch /root/.ssh/known_hosts \
 && ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN git config --global user.email "sbm.kvp@gmail.com"
RUN git config --global user.name "Bala S"
RUN git config --global pull.rebase false
RUN git clone --depth=1 git@github.com:sbmkvp/rta_booking_information.git /app
RUN echo "Australia/Sydney" > /etc/timezone && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/Australia/Sydney /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

COPY settings.json /app/settings.json
WORKDIR /app

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

CMD ["./get_all_locations.sh"]
