# Challenge

Challenge
Introduction
The following challenge was tackled using two different approaches. The initial method involved attempting to solve the problem by downloading the data. In this approach, the data is first fetched, and then the results are processed. Subsequently, after successfully resolving the challenge using this method, an alternative approach was explored by attempting to stream the data. This means that instead of downloading the data into files, it involves processing the data on the fly as requests are made to the URLs where the information is located.

It's worth mentioning that both Solution 1 and Solution 2 were developed using the default server and database that comes installed with PostgreSQL. Therefore, to run both solutions, it's necessary for the user to have PostgreSQL downloaded and installed. In my case, I have PostgreSQL 15 installed, and the details for the default server and database are as follows:

Server: PostgreSQL 15
Database: postgres
Host: localhost
Port: 5432
Username: postgres
Additionally, the user must have postgREST installed. The repository contains the respective installers for postgREST at the provided addresses.

IMPORTANT: TO RUN ANY OF THE SOLUTIONS, IS IMPORTANT NOT TO MOVE ANY FILE FROM IT'S LOCATION. JUST DOWNLOAD FOLDERS SOLUTION 1, SOLUTION 2, LOCATED WERE EVER YOU WANT AND RUN THE CORRESPONDING FILES.

Solution 1
Explanation
As mentioned earlier, in this solution, the data is downloaded and saved in .txt files (located in the 'txt' folder). This process is carried out using Python, and the code responsible for it can be found in the 'URL_to_txt.ipynb' file. To simplify, the necessary txt files for data processing are already provided. In the 'Queries' folder, the 'Main.sql' file processes the data from the txt files to make it ready for viewing through an API request.

Within the 'API' folder, the 'postgrest.exe' and the API configuration file are located. These files are essential for running the API, allowing HTTP requests to the database tables. Finally, a .bat file has been generated, initiating a wizard-like interface where the user can input information about the server, database, etc., to which they want to connect, as well as the paths where the files are located on their PC.

How to Run It
After downloading the 'Solution 1' folder, open the .bat file and follow the wizard's instructions. It is crucial to enter the paths correctly for the .bat to run successfully and to:

Execute the query.
Store data from the txt files.
Process the data.
Start the API.
Set up the environment to open a browser and make HTTP requests.
Note: Pressing 'Enter' without entering any text uses the default values mentioned.

Once the Main.bat is executed, perform HTTP requests to view the two indicators required in the challenge:

http://localhost:3000/women_in_government
http://localhost:3000/ratio

Solution 2
Explanation
In this solution, the goal is not to download the data. Instead, the aim is to stream the data by making requests to the URLs where the data is located. These requests retrieve 'chunks' of data, rather than all the data, which are then processed in chunks. This approach avoids the need to download large volumes of data into files.

How to Run It
Two methods were developed for running this solution:

Jupyter Notebook Method:

Use a Jupyter notebook (Main.ipynb) that executes all the necessary tasks to solve the challenge. The notebook runs both Python and SQL code, and no additional files are required since the queries are embedded within the notebook. Additionally, the notebook starts the API once the data is processed and opens a browser to make the required requests.
To execute:
Run the entire Jupyter notebook (Main.ipynb).
Python Script Method:

Utilize a set of Python scripts, including a main script (Main.py) responsible for calling the queries, inputting them into the data processing function, and finally starting the API to make requests.
To execute:
Run the Main.py script in Spyder, VS Code, or a similar environment.
Prerequisites
The files import the following libraries:

Database Analysis:
Women in Government:
For the "Women in Government" indicator, we extracted the CES (Current Employment Statistics) code for the government sector. After interpreting the codes and exploring the database, we identified that the series ID is CES9000000010. Here, '90' corresponds to the super sector code for government, and '10' corresponds to women employees.

Ratio Production/Supervisory Employees:
For the "Ratio Production/Supervisory Employees" indicator, we considered the CES for total private. The required series IDs are:

CES0500000006 (Production and nonsupervisory employees, thousands, total private, seasonally adjusted): '05' corresponds to the sector, supersector all private, and '05' to production employees. There are 22,699 rows for this series.
CES0000000001 (All employees, thousands, total nonfarm, seasonally adjusted): '00' corresponds to the supersector total nonfarm, and '01' to all employees.
Note: The ratio will be calculated between all non-farm employees and production employees in all private. Using the information from the provided table, we identified the supersectors belonging to the category of all private. All supersectors except government and service providing belong to all private. Taking the production of all private is equivalent to taking the production of all these sectors. We do not consider the production of the missing supersectors (government, etc.), and then we assume that all nonfarm employees are all employees of all categories, making this the total ratio:
ratio
=
production all private
all employees nonfarm
−
production all private
ratio= 
all employees nonfarm−production all private
production all private
​
 

However, this indicator can be discussed with team members to correctly identify what each category represents.

Conclusion:
The results revealed a significant growth in women's employment over the years. On the other hand, the ratio between "production employees" and "supervisory employees" remained fairly constant.

An Alternative Way:
Another alternative to solving the challenge could be to set up a server and a database in a Docker container. This approach would make it easier to run the challenge, as the container, along with the code, can be shared to ensure that the server and the database used for storing and processing the data are consistent.
