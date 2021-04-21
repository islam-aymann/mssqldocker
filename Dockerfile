FROM python:3.7.10-alpine3.13 as base

RUN apk --no-cache add --virtual build-dependencies\
 libffi-dev musl-dev linux-headers unixodbc-dev gcc\
  g++ curl git python3-dev jpeg-dev zlib-dev gettext postgresql-dev build-base

COPY requirements requirements
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /wheels -r requirements/development.txt

FROM python:3.7.10-alpine3.13

RUN apk --no-cache add --virtual build-dependencies\
 libffi-dev musl-dev linux-headers unixodbc-dev gcc\
  g++ curl git python3-dev jpeg-dev zlib-dev gettext postgresql-dev build-base

# Microsoft ODBC driver for SQL Server
#Download the desired package(s)
RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.7.1.1-1_amd64.apk \
&& curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.7.1.1-1_amd64.apk \
&& apk add --allow-untrusted msodbcsql17_17.7.1.1-1_amd64.apk\
&& apk add --allow-untrusted mssql-tools_17.7.1.1-1_amd64.apk

RUN rm msodbcsql17_17.7.1.1-1_amd64.apk && rm mssql-tools_17.7.1.1-1_amd64.apk

ENV PYTHONDONTWRITEBYTECODE 1

ENV PYTHONUNBUFFERED 1

# install dependencies
COPY --from=base /wheels /wheels
COPY --from=base requirements requirements
RUN pip install --no-cache /wheels/*

WORKDIR /opt/project
COPY . /opt/project

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["/opt/project/entrypoint.sh"]