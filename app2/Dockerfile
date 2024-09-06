FROM python:alpine

WORKDIR /app

COPY ./app2/requirements.txt  ./requirements.txt

RUN pip install --no-cache-dir --upgrade -r /requirements.txt

COPY ./app2 .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]