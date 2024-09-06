FROM python:3.11-slim

WORKDIR /app

COPY ./app1/requirements.txt ./requirements.txt

RUN pip install --no-cache-dir --upgrade -r requirements.txt

COPY ./app1 .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]