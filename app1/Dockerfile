# base defines a base stage that uses the official python runtime base image
FROM python:3.13-alpine AS base

# Add curl for healthcheck
RUN apk add --no-cache curl bash

# Set the application directory
WORKDIR /app

# Create and activate a virtual environment
RUN python -m venv /app/venv

# Ensure the venv is activated for all subsequent commands
ENV PATH="/app/venv/bin:$PATH"


# Install our requirements.txt
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Second stage
FROM python:3.13-alpine

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

USER appuser

COPY --from=base /app /app

COPY . .

ENV PATH="/app/venv/bin:$PATH"

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]