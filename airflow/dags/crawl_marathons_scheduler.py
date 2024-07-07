from airflow import DAG
from airflow.decorators import task
from airflow.utils.dates import days_ago
from datetime import timedelta
import subprocess

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'scrapy_spider_dag',
    default_args=default_args,
    description='A simple DAG to run a Scrapy spider',
    schedule_interval=timedelta(days=1),
    start_date=days_ago(1),
    catchup=False,
)

@task
def run_scrapy_spider():
    project_path = "/Users/donghyo/Desktop/crawl_data/scrapy/runners/"  # 절대 경로 사용
    spider_name = "example"  # 실행할 스파이더의 이름
    subprocess.run(
        ["scrapy", "crawl", spider_name],
        cwd=project_path,
        check=True
    )

with dag:
    run_scrapy_spider_task = run_scrapy_spider()
