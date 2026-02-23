FROM grafana/grafana:latest

# Switch to root to install dependencies
USER root

# Install Python and pip
RUN apk add --no-cache python3 py3-pip supervisor

# Create app directory for Flask
WORKDIR /app

# Copy Flask API files
COPY flask_api.py .
COPY requirements-api.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --break-system-packages -r requirements-api.txt

# Install Grafana plugin
ENV GF_INSTALL_PLUGINS="yesoreyeram-infinity-datasource"

# Copy Grafana provisioning and dashboards
COPY provisioning /etc/grafana/provisioning
COPY dashboards /var/lib/grafana/dashboards

# Copy supervisor config to manage both processes
COPY supervisord.conf /etc/supervisord.conf

# Expose only the Grafana port (Render expects one port)
# Flask runs internally on 8000, Grafana proxies or both are accessible
EXPOSE 3000

# Use supervisor to run both Grafana and Flask
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
