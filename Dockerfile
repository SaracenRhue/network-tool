FROM python:3.10-slim

WORKDIR /home/app

COPY . .

RUN pip install flask

EXPOSE 3000
ENV PORT=3000

CMD python server.py