# Base image for Airflow 2.9.2
FROM apache/airflow:2.9.2-python3.9

# Install Poetry
USER root
RUN apt-get update && apt-get install -y curl && \
    curl -sSL https://install.python-poetry.org | POETRY_HOME=/etc/poetry python3 - && \
    ln -s /etc/poetry/bin/poetry /usr/local/bin/poetry

# Create directories for Airflow and Scrapy
RUN mkdir -p /usr/local/airflow/dags /usr/local/airflow/logs /usr/local/airflow/plugins
RUN mkdir -p /usr/local/scrapy

# Copy Poetry configuration and install dependencies
COPY pyproject.toml poetry.lock /usr/local/airflow/
RUN cd /usr/local/airflow && poetry config virtualenvs.create false && poetry install --no-dev

# Set environment variables
ENV AIRFLOW_HOME=/usr/local/airflow

# Copy Airflow DAGs and Scrapy project
COPY airflow/dags /usr/local/airflow/dags
COPY scrapy /usr/local/scrapy

# Set permissions
RUN chown -R airflow: /usr/local/airflow /usr/local/scrapy

# Switch to airflow user
USER airflow

# Set the entrypoint to Airflow
ENTRYPOINT ["entrypoint.sh"]

# Default command is to start the webserver
CMD ["webserver"]
