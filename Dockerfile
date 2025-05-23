FROM python:3.12-slim AS builder

# Set environment variables to prevent Python from writing .pyc and create a non-root user
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100

# Set the working directory
WORKDIR /app

# Copy and install dependencies separately for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Use a lightweight runtime stage
FROM python:3.12-slim

# Set environment variables again in final stage
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Copy only the installed dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application source code
COPY . .

# Ensure a non-root user runs the container
RUN useradd -m appuser && chown -R appuser /app
USER appuser

# Expose port
EXPOSE 5000

# Command to run the application
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
