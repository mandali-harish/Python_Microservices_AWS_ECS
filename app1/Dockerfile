FROM python:alpine

WORKDIR /app

COPY ./requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

COPY . /app/app1

CMD ["uvicorn", "app1/main:app", "--host", "0.0.0.0", "--port", "80"]