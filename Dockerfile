FROM python:3.8

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable

RUN apt-get install -y jq
RUN apt-get install -y parallel
RUN apt-get install -y git
RUN apt-get install -yqq unzip
RUN wget -O /tmp/chromedriver.zip https://storage.googleapis.com/chrome-for-testing-public/`curl -sS https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_STABLE`/linux64/chromedriver-linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver-linux64/chromedriver -d /usr/local/bin/
ENV DISPLAY=:99


COPY gitconfig /root/.gitconfig
COPY git-credentials /root/.git-credentials
RUN git clone --depth=1 https://github.com/sbmkvp/rta_booking_information /app
COPY settings.json /app/settings.json
WORKDIR /app

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

CMD ["./get_all_locations.sh"]
