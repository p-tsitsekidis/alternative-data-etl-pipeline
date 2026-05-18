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

# Create a virtual environment and install packages inside it. 
# This bypasses all global root vs. user permission quirks.
RUN python3 -m venv /app/venv
RUN /app/venv/bin/pip install --no-cache-dir -r requirements-api.txt

# Copy the start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Install Grafana plugins
ENV GF_INSTALL_PLUGINS="yesoreyeram-infinity-datasource"

ENV GF_PLUGINS_PREINSTALL_DISABLED=true
ENV GF_UNIFIED_ALERTING_ENABLED=false
ENV GF_ALERTING_ENABLED=false
ENV GF_ANALYTICS_REPORTING_ENABLED=false
ENV GF_ANALYTICS_CHECK_FOR_UPDATES=false
ENV GF_ANALYTICS_CHECK_FOR_PLUGIN_UPDATES=false

# Copy Grafana provisioning and dashboards
COPY provisioning /etc/grafana/provisioning
COPY dashboards /var/lib/grafana/dashboards

# Give the grafana user total ownership of the app and its virtual environment
RUN chown -R grafana:root /app /start.sh

# Switch back to grafana user
USER grafana

EXPOSE 3000

ENTRYPOINT ["/start.sh"]