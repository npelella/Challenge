# Challenge Solver

## Introduction

The challenge was approached using two different methods. Initially, an attempt was made to solve the problem by downloading the data. In this approach, the data is fetched, and the results are processed. Subsequently, an alternative approach was explored, streaming the data by processing it on the fly as requests are made to the URLs where the information is located.

Both Solution 1 and Solution 2 were developed using the default server and database that comes installed with PostgreSQL. To run both solutions, PostgreSQL must be downloaded and installed. The details for the default server and database are as follows:

- Server: PostgreSQL 15
- Database: postgres
- Host: localhost
- Port: 5432
- Username: postgres

Additionally, postgREST must be installed, and the repository contains the respective installers for postgREST at the provided addresses.

**IMPORTANT:** To run any of the solutions, do not move any file from its location. Just download folders Solution 1, Solution 2, located wherever you want, and run the corresponding files.

## Solution 1

### Explanation

In this solution, data is downloaded and saved in .txt files using Python ('URL_to_txt.ipynb'). The necessary txt files for data processing are already provided. 'Main.sql' in the 'Queries' folder processes the data for viewing through an API request.

In the 'API' folder, 'postgrest.exe' and the API configuration file are located, essential for running the API and allowing HTTP requests to the database tables. A .bat file has been generated for a user-friendly setup, where the user inputs information about the server, database, etc., and paths to files on their PC.

### How to Run It

After downloading the 'Solution 1' folder, open the .bat file and follow the wizard's instructions. Enter paths correctly for the .bat to run successfully:

1. Execute the query.
2. Store data from the txt files.
3. Process the data.
4. Start the API.
5. Set up the environment to open a browser and make HTTP requests.

**Note:** Pressing 'Enter' without entering any text uses the default values mentioned.

Once Main.bat is executed, perform HTTP requests to view the two indicators required in the challenge:

- [http://localhost:3000/women_in_government](http://localhost:3000/women_in_government)
- [http://localhost:3000/ratio](http://localhost:3000/ratio)

## Solution 2

### Explanation

In this solution, the goal is to stream the data by making requests to the URLs where the data is located. Requests retrieve 'chunks' of data, avoiding the need to download large volumes of data into files.

### How to Run It

Two methods were developed for running this solution:

#### Jupyter Notebook Method:

- Use a Jupyter notebook ('Main.ipynb') that executes necessary tasks. The notebook runs both Python and SQL code, and no additional files are required since the queries are embedded within the notebook. The notebook starts the API once the data is processed and opens a browser to make required requests.
  - To execute: Run the entire Jupyter notebook ('Main.ipynb').

#### Python Script Method:

- Utilize Python scripts, including a main script ('Main.py') responsible for calling queries, inputting them into the data processing function, and finally starting the API to make requests.
  - To execute: Run the Main.py script in Spyder, VS Code, or a similar environment.

### Prerequisites

The files import the following libraries:

- pandas
- sqlite3
- io
- requests
- psycopg2
- sqlalchemy
- os
- subprocess
- webbrowser

## Database Analysis

### Women in Government

For the "Women in Government" indicator, the CES (Current Employment Statistics) code for the government sector was extracted. The series ID is CES9000000010, where '90' corresponds to the super sector code for government, and '10' corresponds to women employees.

### Ratio Production/Supervisory Employees

For the "Ratio Production/Supervisory Employees" indicator, the CES for total private was considered. The required series IDs are:

- CES0500000006 (Production and nonsupervisory employees, thousands, total private, seasonally adjusted): '05' corresponds to the sector, supersector all private, and '05' to production employees. There are 22,699 rows for this series.
- CES0000000001 (All employees, thousands, total nonfarm, seasonally adjusted): '00' corresponds to the supersector total nonfarm, and '01' to all employees.

The ratio is calculated between all non-farm employees and production employees in all private. The indicator can be discussed with team members to correctly identify what each category represents.

## Conclusion

The results reveal significant growth in women's employment over the years. On the other hand, the ratio between "production employees" and "supervisory employees" remained fairly constant.

## An Alternative Way

Another alternative to solving the challenge could be to set up a server and a database in a Docker container. This approach would make it easier to run the challenge,
