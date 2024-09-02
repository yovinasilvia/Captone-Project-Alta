from cosmos.config import ProfileConfig, ProjectConfig
from pathlib import Path

DBT_CONFIG = ProfileConfig(
    profile_name='analys', # nama fraudnya disesuaikan dgn nama project dbtnya
    target_name='dev',
    profiles_yml_filepath=Path('/opt/airflow/dags/dbt/analys/profiles/profiles.yml')  # nama fraudnya disesuaikan dgn nama project dbtnya
)

DBT_PROJECT_CONFIG = ProjectConfig(
    dbt_project_path='/opt/airflow/dags/dbt/analys/', # nama fraudnya disesuaikan dgn nama project dbtnya
)
