# base defines a base stage that uses the official python runtime base image
FROM python:3.13-slim AS base

# Add curl for healthcheck
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Set the application directory
WORKDIR /app

# Install our requirements.txt
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# dev defines a stage for development, where it'll watch for filesystem changes
FROM base AS dev
CMD ["python", "main.py"]

FROM base AS final
COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]