# Project - Edugrade - Linux 2 - Team 1

## Project Description
This project is a bash script that reads a text file with a list of URLs, separated by a line break,
and checks the expire date for their certificates. The script sends a notification to a target group
that it is time to renew the certificate(s) of the URL(s) whose certificates are about to expire.

This project is a partial requirement for the course *Linux 2*, part of the program *Linux DevOps Engineer - distance*
at *Edugrade* in Sweden (fall 2021).


## Authors:
| Name            | Email address                | GitHub username |
| --------------- |:----------------------------:| ---------------:|
| Rafael Silva    |rasilva.1986@gmail.com        |rasi10           |
| Adil Riaz       |adilriaz001@hotmail.com       |adilriaz001      |
| Ahmed Aaden     |ahmed.aaden@edugrade.se       |ahaad74          |
| Joakim Larsson  |joakim.larsson@edu.edugrade.se|youreakim        |
| Ghulam Mustafa  |ghulam.mustafa@edu.edugrade.se|mustafaedugrade  |
| Joshua Lutakome |       |     |



## Required packages to be installed:
```
openssl
ssmtp
mailutils
curl
```

## How to run the project in your terminal:
```
Firstly, make sure to have a text file with a list of URLs. For instance, you can create a file called 'myURLs.txt' with the folowing content:
______________
|myURLs.txt   |
---------------
|edugrade.se  |
|wikipedia.com|
|google.com   |
|_____________|

Making the script executable & mandatory flags:
'chmod 770 certificate-monitor.sh'
'sh certificate-monitor.sh -f <filename> -d <limitAcceptedDays>'

Example with mandatory flags:
Ex: 'sh certificate-monitor.sh -f myURLs.txt -d 10'

Getting help:
'sh certificate-monitor -h'
```

## How to run the project with docker:
```
// TO DO
```

v1 - _November 3rd, 2021_