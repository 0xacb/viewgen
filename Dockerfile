FROM python:3.11-alpine as base

FROM base as build

WORKDIR /build

RUN apk add gcc musl-dev
COPY requirements.txt /requirements.txt
RUN pip install --prefix /build -r /requirements.txt

FROM base

COPY --from=build /build /usr/local

WORKDIR /tool

COPY viewgen /tool
RUN chmod +x viewgen

ENTRYPOINT ["/tool/viewgen"]
