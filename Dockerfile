FROM grafana/grafana:latest

# Switch to root for installing dependencies
USER root

# Install Python and pip
RUN apk add --no-cache python3 py3-pip

# Create app directory
WORKDIR /app

# Copy Flask API files
COPY flask_api.py .
COPY requirements-api.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --break-system-packages -r requirements-api.txt

# Copy the start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Install Grafana plugins
ENV GF_INSTALL_PLUGINS="yesoreyeram-infinity-datasource"

# Copy Grafana provisioning and dashboards
COPY provisioning /etc/grafana/provisioning
COPY dashboards /var/lib/grafana/dashboards

# Make sure grafana user can access the app
RUN chown -R grafana:root /app

# Switch back to grafana user
USER grafana

EXPOSE 3000

CMD ["/start.sh"]
