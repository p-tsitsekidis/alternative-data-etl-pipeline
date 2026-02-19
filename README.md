# Alternative Data ETL Pipeline

An end-to-end data engineering pipeline and REST API bridging **environmental sensor time-series** and **AI-driven local news enrichment**. 

Developed as an undergraduate thesis in Computer Science, this project demonstrates how to ingest, parse, and correlate unstructured alternative data (news events) with physical sensor readings to identify causal relationships. 



## Technical Highlights & Architecture

### 1. Data Engineering & Automation
* **Automated Ingestion:** Utilizes Selenium and BeautifulSoup to continuously scrape local news and download daily PurpleAir PM2.5 CSV datasets.
* **Time-Series Alignment:** Cleans and aggregates asynchronous sensor data using `pandas`, aligning high-frequency sensor ticks into normalized daily averages to match news event timelines.
* **Local LLM Inference:** Employs LM Studio for local, cost-free NLP processing. The LLM extracts named entities, classifies event types (e.g., traffic, fires, public gatherings), and identifies specific dates/locations directly from unstructured Greek text.

### 2. Algorithmic Rigor
* **Geospatial Correlation:** Implements the **Haversine formula** to calculate great-circle distances, autonomously mapping geocoded news events to the nearest air quality sensor within a strict $O(N)$ threshold validation.
* **REST API Layer:** A Flask backend serves the aggregated data, executing complex PyMongo queries to filter time-series and categorical data dynamically based on user parameters.

## Repository Structure

| File / Module | Description |
|----------------|-------------|
| `articles_pipeline.py` | Scrapes, geocodes (Google APIs), and enriches local news using local LLMs. |
| `sensor_readings_pipeline.py` | Headless Selenium scraper and Pandas aggregator for PurpleAir CSVs. |
| `flask_api.py` | Flask REST API serving time-series and categorical data to the frontend. |
| `dashboards/` | Exported Grafana dashboards (`thesis.json`) for data visualization. |

## Setup & Deployment

The system is fully containerized and live-hosted (Docker + Render). 

### Local Installation
1. **Clone the Repository:**
    ```bash
    git clone [https://github.com/p-tsitsekidis/article-sensor-analytics.git](https://github.com/p-tsitsekidis/article-sensor-analytics.git)
    cd article-sensor-analytics
    ```

2. **Environment & Dependencies:**
    ```bash
    python -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
    ```


3. **Configuration:** Copy `.env.example` to `.env` and provide your MongoDB URI, LM Studio URL, and Google API keys.

## Live Visualization

The Flask backend powers a dynamic Grafana dashboard featuring:

* Correlated time-series line charts of PM2.5 anomalies.
* Tag frequency distributions (Pie Charts).
* Geospatial aggregations across multiple sensor nodes.

👉 **[Access the Live Dashboard Here](https://thesis-grafana.onrender.com)** *(Navigate to **Dynamic Sensor and Article Data Dashboard** under Dashboards)*

## Future Roadmap

To scale this architecture for high-frequency trading or enterprise environments, future iterations would focus on:

* **Asynchronous I/O:** Migrating the synchronous scraping pipeline to `aiohttp` and `asyncio` for significantly faster data ingestion.
* **Event Streaming:** Introducing Apache Kafka to transition from batch-based cron jobs to real-time event streaming.
* **Vector Database Integration:** Migrating from standard text matching to storing article embeddings in a Vector DB (like Milvus or Pinecone) for semantic similarity searches.

## License

This project is licensed under the **MIT License**.

---

© 2025 Petros Tsitsekidis. All rights reserved.
