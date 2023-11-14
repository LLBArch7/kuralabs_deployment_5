FROM python:latest

RUN apt update && apt -y install git

RUN git clone https://github.com/LLBArch7/kuralabs_deployment_5.git

WORKDIR /kuralabs_deployment_5

RUN pip install -r requirements.txt

EXPOSE 5000

ENTRYPOINT FLASK_APP=application flask run --host=0.0.0.0
