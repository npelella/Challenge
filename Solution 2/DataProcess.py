import pandas as pd
from io import StringIO
import requests

# Function to stream and process data
def stream_and_process_data(url, engine, process_data, conn, cursor, table_name, chunk_size=10000):
    
    # Use 'requests' to stream data from the URL
    # Define the custom headers
    headers = {
        'authority': 'www.google.com',
        'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
        'accept-language': 'en-US,en;q=0.9',
        'cache-control': 'max-age=0',
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36',
    }
    
    response = requests.get(url, stream=True, headers=headers)
    
    # Initialize an empty string to accumulate lines
    data_buffer = ""
    decoded_first_line=""
    for line in response.iter_lines():
        if line:
            if data_buffer=="" and decoded_first_line=="":
                decoded_first_line = line.decode('utf-8')
                data_buffer += decoded_first_line + "\n"
            elif data_buffer=="" and decoded_first_line!="":
                decoded_line = line.decode('utf-8')
                data_buffer += decoded_first_line + "\n"
                data_buffer += decoded_line + "\n"
            else:
                decoded_line = line.decode('utf-8')
                data_buffer += decoded_line + "\n"

            # Count the number of lines in the string
            line_count = data_buffer.count('\n') + 1
            
            # Check if the buffer size exceeds the chunk size
            if line_count >= chunk_size:
                # Convert the buffer to a Pandas DataFrame
                df_chunk = pd.read_csv(StringIO(data_buffer), delimiter='\t')
                
                # Step 1: Remove empty spaces from column names
                df_chunk.columns = df_chunk.columns.str.strip()
                df_chunk['series_id'] = df_chunk['series_id'].str.strip()

                # Step 2: Convert 'year' and 'value' columns to string
                df_chunk['year'] = df_chunk['year'].astype(str)
                df_chunk['value'] = df_chunk['value'].astype(str)

                # Step 3: Replace NaN values in 'footnote_codes' with an empty string
                df_chunk['footnote_codes'].fillna('', inplace=True)
                
                # Process the data
                
                df_chunk.to_sql(table_name, engine, if_exists='replace', index=False, schema='api')
                
                cursor.execute(process_data)
                conn.commit()

                # Reset the buffer
                line_count = 0
                data_buffer = ""
    
    if data_buffer != "":
        df_chunk = pd.read_csv(StringIO(data_buffer), delimiter='\t')
        
        # Step 1: Remove empty spaces from column names and series_id
        df_chunk.columns = df_chunk.columns.str.strip()
        df_chunk['series_id'] = df_chunk['series_id'].str.strip()
        
        # Step 2: Convert 'year' and 'value' columns to string
        df_chunk['year'] = df_chunk['year'].astype(str)
        df_chunk['value'] = df_chunk['value'].astype(str)

        # Step 3: Replace NaN values in 'footnote_codes' with an empty string
        df_chunk['footnote_codes'].fillna('', inplace=True)
        
        df_chunk.to_sql(table_name, engine, if_exists='replace', index=False, schema='api')
        
        cursor.execute(process_data)
        conn.commit()