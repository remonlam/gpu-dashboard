FROM alpine:3.20

ENV PYTHONUNBUFFERED=1

# Install system + build dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    curl \
    build-base \
    python3-dev \
    musl-dev \
    linux-headers \
    libffi-dev \
    openssl-dev

# Create virtual environment
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

WORKDIR /app

COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p templates

EXPOSE 1312

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:1312/api/gpu-data || exit 1

CMD ["python", "app.py"]