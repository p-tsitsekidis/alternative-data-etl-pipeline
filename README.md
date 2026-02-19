# Alternative Data ETL Pipeline

## Overview

This project bridges **environmental sensor analytics** and **AI-driven news enrichment** for the city of Patras, Greece.
It was developed as part of a Computer Science thesis to study how **local events** influence **air quality**.
The system uses pipelines, enriches, and visualizes data in a full-stack architecture — from raw text and sensor readings to Grafana dashboards.

---

## Features

- **Article Enrichment:** Scrapes and classifies local news using LLMs (via LM Studio)
- **Geospatial Mapping:** Geocodes article locations and links them to nearby air sensors
- **Environmental Data:** Automates daily PurpleAir data ingestion with Selenium
- **MongoDB Integration:** Centralized data storage for analytics and dashboards
- **Grafana API Integration:** Provides REST endpoints for real-time visualization
- **Docker + Render Deployment:** Fully containerized and live-hosted system

---

## Repository Structure

| Folder / File | Description |
|----------------|-------------|
| `articles_pipeline.py` | Scrapes, enriches, and tags local news articles using LLMs |
| `sensor_readings_pipeline.py` | Collects and aggregates daily PurpleAir PM2.5 readings |
| `flask_api.py` | Flask application serving data to Grafana |
| `dashboards/` | Contains exported Grafana dashboards (`thesis.json`) |
| `prompts/` | LLM prompts for text enrichment (e.g., tagging, summarization) |
| `provisioning/` | Grafana provisioning files for dashboards |
| `requirements.txt` | Full dependency list |
| `requirements-api.txt` | Minimal dependencies for API-only deployment |
| `LICENSE` | MIT license |
| `.env.example` | Template for environment configuration |

---

## Setup

### 1. Clone the Repository
```bash
git clone https://github.com/p-tsitsekidis/article-sensor-analytics.git
cd article-sensor-analytics
```

### 2. Create a Virtual Environment
```bash
python -m venv .venv
source .venv/bin/activate   # On Windows: .venv\Scripts\activate
```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
```

### 4. Configure Environment Variables
Copy and edit the template:
```bash
cp .env.example .env
```
Update with your credentials:
- MongoDB URI and collection names  
- LM Studio URL and model IDs  
- Google API Key (for Geocoding & Places)

---

## REST API Endpoints

| Endpoint | Description |
|-----------|-------------|
| `/api/filtered_readings` | Sensor-level time series filtered by tag |
| `/api/area_filtered_readings` | Area-level averages |
| `/api/sensor_article_urls` | Relevant articles for a specific sensor |
| `/api/area_article_urls` | Relevant articles for a given area |
| `/api/primary_tag_piechart` | Distribution of primary tags |
| `/api/average_2024`, `/api/average_2025` | Yearly sensor averages |

---

## Live Visualization

The Flask backend powers a dynamic Grafana dashboard featuring:
- Correlated time-series line charts of PM2.5 anomalies.
- Tag frequency distributions.
- Interactive datasets with live origin URLs.
- Geospatial aggregations across multiple sensor nodes.

To access the live dashboard:  
👉 [https://thesis-grafana.onrender.com](https://thesis-grafana.onrender.com)  
Then open **Dynamic Sensor and Article Data Dashboard** under *Dashboards*.

---

## Technologies Used

| Layer | Stack |
|-------|--------|
| **Backend** | Python (Flask, Requests, PyMongo, Pandas) |
| **Database** | MongoDB Atlas |
| **Frontend (Visualization)** | Grafana + Infinity Plugin |
| **AI/LLMs** | LM Studio (local inference) |
| **Deployment** | Render (Docker-based) |
| **Automation** | cron/Task scheduler |

---

## Future Improvements
To scale this architecture for high-frequency or enterprise environments, future iterations would include:

- **Asynchronous I/O:** Migrating the synchronous requests scraping pipeline to aiohttp and asyncio for significantly faster data ingestion.

- **Message Brokering:** Introducing Apache Kafka or RabbitMQ to transition from batch-based cron jobs to real-time event streaming.

- **Vector Database Integration:** Migrating from standard text matching to storing article embeddings in a Vector DB (like Pinecone or Milvus) for semantic similarity search.

---

## License

This project is licensed under the **MIT License**.

---

© 2025 Petros Tsitsekidis. All rights reserved.
