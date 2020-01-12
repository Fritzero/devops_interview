FROM python:3.7.6-slim

RUN apt-get update -y && \
    apt-get install -y python-pip python-dev

COPY webserver/requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install -r requirements.txt

COPY webserver /app

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]
