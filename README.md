# Project - Edugrade - Linux 2 - Team 1

## _Project Description_
This project is a bash script that reads a text file with a list of URLs, separated by a line break,
and checks the expire date for their certificates. The script sends a notification to a target group
that it is time to renew the certificate(s) of the URL(s) whose certificates are about to expire.

This project is a partial requirement for the course *Linux 2*, part of the program *Linux DevOps Engineer - distance*
at *Edugrade* in Sweden (fall 2021).


## _Authors_
| Name            | Email address                 | GitHub username |
| --------------- |:-----------------------------:| ---------------:|
| Rafael Silva    |rasilva.1986@gmail.com         |rasi10           |
| Adil Riaz       |adilriaz001@hotmail.com        |adilriaz001      |
| Ahmed Aaden     |ahmed.aaden@edugrade.se        |ahaad74          |
| Joakim Larsson  |joakim.larsson@edu.edugrade.se |youreakim        |
| Ghulam Mustafa  |ghulam.mustafa@edu.edugrade.se |mustafaedugrade  |
| Joshua Lutakome |joshua.lutakome@edu.edugrade.se|joshua-devops    |



## _Required packages to be installed_
```
openssl
ssmtp
mailutils
sendmail
curl
```

## _Configuring a SMTP server on your machine with a office365 account_
- Install the required packages.
- Read the content of the files **Revaliases** and **ssmtp.config**, edit them and save them under **/etc/ssmtp**

## _How to run the project in your terminal_
Make sure to have a text file with a list of URLs. You can create, for instance, a file named "myURLs.txt" with the folowing content:
```
______________
|myURLs.txt   |
---------------
|edugrade.se  |
|wikipedia.com|
|google.com   |
|_____________|

```

### Making the script executable & mandatory flags:

```sh
chmod 770 certificate-monitor.sh
sh certificate-monitor.sh -t <targetEmail> -d <limitAcceptedDays> -f <filename>

```

Example with mandatory flags:
```sh
sh certificate-monitor.sh -t target-email@email.com -d 10 -f myURLs.txt 
```
Getting help:
```sh
sh certificate-monitor -h
```

## How to run the project with docker:
```
// TO DO
```

v1 - _November 3rd, 2021_