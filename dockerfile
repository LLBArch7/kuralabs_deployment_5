FROM python:latest

RUN apt update

WORKDIR /app

ADD ./URL_shortner.tgz .

RUN pip install -r requirements.txt

EXPOSE 5000

ENTRYPOINT FLASK_APP=application flask run --host=0.0.0.0
