#!/bin/sh

# Force unbuffered Python output so logs appear instantly in Render
export PYTHONUNBUFFERED=1

echo "Starting Flask API in the background..."

# Use the virtual environment's gunicorn and bind to 0.0.0.0.
# Send all output to a log file.
/app/venv/bin/gunicorn -w 2 --threads 2 -k gthread --timeout 120 -b 0.0.0.0:8000 flask_api:app > /app/api.log 2>&1 &

# Run a background process to constantly print the API logs to Render's console
tail -f /app/api.log &

# Wait a few seconds for Flask to boot up
sleep 3

echo "Starting Grafana..."
exec /run.sh