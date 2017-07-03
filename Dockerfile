FROM ubuntu:latest

COPY . /xpeppers
WORKDIR  /xpeppers

RUN apt-get update && apt-get install -y imagemagick socat file wget
RUN chmod +x http.sh

EXPOSE 8080

CMD ["socat", "TCP4-LISTEN:8080,fork", "EXEC:./http.sh"]