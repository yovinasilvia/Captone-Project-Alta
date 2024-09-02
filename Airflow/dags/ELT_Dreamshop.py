from pendulum import datetime
from airflow.decorators import dag, task, task_group
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.models.baseoperator import chain

from cosmos import DbtDag
from cosmos.operators import DbtDocsOperator
from cosmos.config import RenderConfig
from cosmos.airflow.task_group import DbtTaskGroup
from cosmos.constants import LoadMode
from dbt.analys.cosmos_config import DBT_CONFIG, DBT_PROJECT_CONFIG

AIRBYTE_CONN_ID = 'bdad854c-cacf-4ffb-b962-3fb4be38bfdd'

# Define the ELT DAG
@dag(
    dag_id="elt_dag",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    tags=["airbyte", "dbt", "bigquery", "elt_dreamshop_data"],
    catchup=False,
)
def extract_and_transform():
    """
    Runs the connection "Faker to BigQuery" on Airbyte and then triggers the dbt DAG.
    """
    # Airbyte sync task
    extract_data = AirbyteTriggerSyncOperator(
        task_id="trigger_airbyte_faker_to_bigquery",
        airbyte_conn_id='airbyte_conn',
        connection_id=AIRBYTE_CONN_ID,  # Menggunakan konstanta yang sudah didefinisikan
        asynchronous=False,
        timeout=3600,
        wait_seconds=3
    )

    # Trigger for dbt DAG
    trigger_dbt_dag = TriggerDagRunOperator(
        task_id="trigger_dbt_dag",
        trigger_dag_id="dbt_dreamshop",
        wait_for_completion=True,
        poke_interval=30,
    )

    extract_data >> trigger_dbt_dag

# Instantiate the ELT DAG
extract_and_transform_dag = extract_and_transform()

# Define the dbt DAG using DbtDag from the cosmos library
dbt_cosmos_dag = DbtDag(
    dag_id="dbt_dreamshop",
    start_date=datetime(2024, 1, 1),
    tags=["dbt", "dreamshop"],
    catchup=False,
    project_config=DBT_PROJECT_CONFIG,
    profile_config=DBT_CONFIG,
    render_config=RenderConfig(
        load_method=LoadMode.DBT_LS,
        select=["path:models"]
    )
)

# Instantiate the dbt DAG
dbt_cosmos_dag
