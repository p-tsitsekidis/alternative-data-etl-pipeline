#!/bin/sh

# Start Flask in the background
cd /app && gunicorn -w 2 --threads 2 -k gthread --timeout 120 --graceful-timeout 60 --keep-alive 5 -b 127.0.0.1:8000 flask_api:app &

# Wait a few seconds for Flask to start
sleep 3

# Start Grafana in the foreground
exec /run.sh
