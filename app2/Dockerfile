FROM python:alpine

# Add curl for healthcheck
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY ./app2/requirements.txt  ./requirements.txt

RUN pip install --no-cache-dir --upgrade -r /requirements.txt

COPY ./app2 .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]