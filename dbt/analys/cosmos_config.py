from cosmos.config import ProfileConfig, ProjectConfig
from pathlib import Path

DBT_CONFIG = ProfileConfig(
    profile_name='analys', # pathnya disesuaikan dgn nama project dbtnya
    target_name='dev',
    profiles_yml_filepath=Path('/opt/airflow/dags/dbt/analys/profiles/profiles.yml')  # pathnya disesuaikan dgn nama project dbtnya
)

DBT_PROJECT_CONFIG = ProjectConfig(
    dbt_project_path='/opt/airflow/dags/dbt/analys/', # pathnya disesuaikan dgn nama project dbtnya
)
