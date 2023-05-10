FROM python:3.10-slim

WORKDIR /home/app

COPY . .

RUN pip install flask

ENV PORT=5500
EXPOSE 5500

CMD python server.py