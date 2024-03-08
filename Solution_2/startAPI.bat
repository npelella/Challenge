
@echo off

rem go to directory where conf file is and start the PostgREST API
start cmd /k "cd C:\Users\NPelella\Nimble\challenge\Solution_2\API && postgrest challenge.conf.txt"

rem Wait for the API to start (adjust timeout as needed)
timeout /t 5
