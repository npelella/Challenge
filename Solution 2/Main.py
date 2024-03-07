from DataProcess import stream_and_process_data
import psycopg2
from sqlalchemy import create_engine
import os
import subprocess
import webbrowser

# Main

# Read SQL scripts from files
notebook_directory = os.getcwd()
queries_path = notebook_directory + '\Queries'

with open(f'{queries_path}/create_table_query.sql', 'r') as file:
    create_table_query = file.read()

with open(f'{queries_path}/process_government_employment.sql', 'r') as file:
    process_government_employment = file.read()

with open(f'{queries_path}/process_totalnonfarm.sql', 'r') as file:
    process_totalnonfarm = file.read()

with open(f'{queries_path}/process_totalprivate_employment.sql', 'r') as file:
    process_totalprivate_employment = file.read()

with open(f'{queries_path}/obtain_ratio.sql', 'r') as file:
    obtain_ratio = file.read()

with open(f'{queries_path}/alter_datatype.sql', 'r') as file:
    alter_datatype = file.read()
    
# PostgreSQL connection details
pg_username = 'postgres'
pg_password = '1234'
pg_host = 'localhost'
pg_port = '5432'
pg_database = 'postgres'

# URL to the data
url_1 = 'https://download.bls.gov/pub/time.series/ce/ce.data.90a.Government.Employment'
url_2 = 'https://download.bls.gov/pub/time.series/ce/ce.data.00a.TotalNonfarm.Employment'
url_3 = 'https://download.bls.gov/pub/time.series/ce/ce.data.05a.TotalPrivate.Employment'

table_name_1 = 'government_employment'
table_name_2 = 'totalnonfarm'
table_name_3 = 'totalprivate_employment'


engine = create_engine(f'postgresql://{pg_username}:{pg_password}@{pg_host}:{pg_port}/{pg_database}')

# Create a PostgreSQL connection and a cursor
conn = psycopg2.connect(
    user=pg_username,
    password=pg_password,
    host=pg_host,
    port=pg_port,
    database=pg_database
)

cursor = conn.cursor()

cursor.execute(create_table_query)
conn.commit()

# Call the function to stream and process data
stream_and_process_data(url_1, engine, process_government_employment, conn, cursor, table_name_1)
stream_and_process_data(url_2, engine, process_totalnonfarm, conn, cursor, table_name_2)
stream_and_process_data(url_3, engine, process_totalprivate_employment, conn, cursor, table_name_3)

cursor.execute(obtain_ratio)
conn.commit()

cursor.execute(alter_datatype)
conn.commit()

# Close the SQLite connection
conn.close()

postgrest_path = notebook_directory + '\API'

# Specify the content of your .bat file
bat_content = fr'''
@echo off

rem go to directory where conf file is and start the PostgREST API
start cmd /k "cd {postgrest_path} && postgrest challenge.conf.txt"

rem Wait for the API to start (adjust timeout as needed)
timeout /t 5
'''

# Specify the path to save the .bat file
bat_file_path = fr'{notebook_directory}\startAPI.bat'

# Write the content to the .bat file
with open(bat_file_path, 'w') as bat_file:
    bat_file.write(bat_content)

result = subprocess.run(bat_file_path, shell=True)

# Open the first URL in the default web browser
webbrowser.open_new_tab('http://localhost:3000/women_in_government')
webbrowser.open_new_tab('http://localhost:3000/ratio')
