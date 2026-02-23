# Alternative Data ETL Pipeline

An end-to-end data engineering pipeline and REST API that correlates **NLP-enriched local news events** with **environmental sensor time-series** (PM2.5 readings) to identify causal relationships between real-world events and air quality anomalies.

The system ingests unstructured Greek news articles, runs them through a multi-stage local LLM classification pipeline, geocodes extracted locations, matches them to the nearest air quality sensor via geospatial proximity, and serves the correlated data through a Flask API powering a live Grafana dashboard.

## Technical Highlights & Architecture

### 1. Data Engineering & Automation
* **Automated Ingestion:** Utilizes Selenium and BeautifulSoup to continuously scrape local news and download daily PurpleAir PM2.5 CSV datasets.
* **Time-Series Alignment:** Cleans and aggregates asynchronous sensor data using `pandas`, aligning high-frequency sensor ticks into normalized daily averages to match news event timelines.
* **Local LLM Inference:** Employs LM Studio for local, cost-free NLP processing. The LLM extracts named entities, classifies event types (e.g., traffic, fires, public gatherings), and identifies specific dates/locations directly from unstructured Greek text.

### 2. Multi-Stage NLP Classification
Each article passes through a sequential enrichment pipeline:
1. **Summarization** — Condensed Greek-language summary via a local Llama model.
2. **Relevancy Filter** — Binary classification to discard unrelated articles.
3. **Primary Tag** — Categorization into one of four event domains (Public Events, Weather, Traffic, Pollution).
4. **Secondary Tag** — Fine-grained sub-classification (e.g., Fires/Arson, Protests, Dust Storms).
5. **Date Extraction** — Resolves affected dates relative to the publication date.

### 3. Geospatial Matching & API Layer
* **Proximity Matching:** Implements the **Haversine formula** to calculate great-circle distances, mapping geocoded news events to the nearest air quality sensor within a configurable threshold.
* **REST API:** A Flask backend serves the aggregated data, executing complex PyMongo queries to filter time-series and categorical data dynamically based on user parameters.

## Repository Structure

| File / Module | Description |
|----------------|-------------|
| `articles_pipeline.py` | Scrapes, geocodes (Google APIs), and enriches local news using local LLMs. |
| `sensor_readings_pipeline.py` | Headless Selenium scraper and Pandas aggregator for PurpleAir CSVs. |
| `flask_api.py` | Flask REST API serving time-series and categorical data to the frontend. |
| `prompts/` | Full prompt library for the multi-stage LLM classification pipeline. |
| `dashboards/` | Exported Grafana dashboards (`thesis.json`) for data visualization. |

## Setup & Deployment

The system is fully containerized and live-hosted (Docker + Render). 

### Local Installation
1. **Clone the Repository:**
    ```bash
    git clone https://github.com/p-tsitsekidis/article-sensor-analytics.git
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

* Correlated time-series bar charts of PM2.5 readings overlaid with news event markers.
* Tag frequency distributions (Pie Charts).
* Geospatial aggregations across multiple sensor nodes (South, Center, North areas).

👉 **[Access the Live Dashboard Here](https://alt-data-dashboard.onrender.com)** *(Navigate to **Dynamic Sensor and Article Data Dashboard** under Dashboards)*

## Future Roadmap

* **Asynchronous I/O:** Migrating the synchronous scraping pipeline to `aiohttp` and `asyncio` for significantly faster data ingestion.
* **Event Streaming:** Introducing Apache Kafka to transition from batch-based cron jobs to real-time event streaming.
* **Vector Database Integration:** Migrating from keyword-based matching to storing article embeddings in a Vector DB (e.g., Milvus or Pinecone) for semantic similarity searches.

## License

This project is licensed under the MIT License.
