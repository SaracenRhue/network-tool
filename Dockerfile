FROM python:3.10-slim

WORKDIR /home/app

COPY . .

RUN pip install flask

ENV PORT=3000
EXPOSE 3000

CMD python server.py