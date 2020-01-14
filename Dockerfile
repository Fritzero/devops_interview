FROM python:3.7.6-slim

RUN apt-get update -y && \
    apt-get install -y python-pip python-dev

COPY webserver/requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install -r requirements.txt

ADD test.sh ./

COPY webserver /app

COPY tests /app

RUN /bin/bash test.sh

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]
