#!/bin/bash

#***************************************************************************#
#                       certificate-monitor.sh                              #
#                                                                           #
#                      Edugrade - Linux 2 - Team 1                          #
#                            Adil Riaz                                      #
#                           Ahmed Aaden                                     #
#                           Rafael Silva                                    #
#                          Joakim Larsson                                   #
#                          Ghulam Mustafa                                   #
#                          Joshua Lutakome                                  #
#                                                                           #
#                       November 3rd, 2021                                  #
#***************************************************************************#

#---------------------------------------------------------------------------#
#      Global constants, global variables, set options, etc                 #
#---------------------------------------------------------------------------#
set -e

NO_ARGS=0
E_OPTERROR=85
E_NORMERROR=0
TODAY=$(date +%s)
NEW_LINE=$'\n'
EMAIL_SENDER="CERTIFICATE-ALERT"
EMAIL_SUBJECT="Certificate alert"
DISCORD_WEBHOOK_URL="" #YOU NEED TO ADD YOUR DISCORD WEBHOOK URL IN HERE!!

email_body=""
unset INPUT_FILE
unset DAYS
unset TARGET_GROUP


#----------------------------------------------------------------------------#
#      normal_usage()                                                        #
#                                                                            #
#      Prints a help message in the terminal that presents how the script's  #
#      is used and in which order the flags are to be placed.                #
#                                                                            #
#      RETURN:                                                               #
#         Only exits successfully (0).                                       #
#                                                                            #
#                                                                            #
#----------------------------------------------------------------------------#
normal_usage() {
    echo "Usage: sh certificate-monitor.sh [-t][-d][-f]"
    echo "    -t [target_email]: The target email (or target group email / alias)"
    echo "    -d [days_threshold]: The number of days used as a threshold"
    echo "    -f [filename]: The name of the file that contains the list of URLs"
    echo ""
    echo "Run 'sh certificate-monitor.sh -h' for help"
    exit $E_NORMERROR
}

#----------------------------------------------------------------------------#
#      wrong_parameters()                                                    #
#                                                                            #
#      Prints a message in the termanl that informs the user of wrongful     #
#      flag placement(s).                                                    #
#                                                                            #
#----------------------------------------------------------------------------#
wrong_parameters() {
    echo "Invalid flag(s)/parameter(s)!"
    echo ""
    echo "Run 'sh certificate-monitor.sh -h' for help"
}

#----------------------------------------------------------------------------#
#      help_message()                                                        #
#                                                                            #
#      Prints a help message in the terminal that presents how the script's  #
#      is used and in which order the flags are to be placed. In addition,   #
#      it also shows a few examples of running the script.                   #
#                                                                            #
#      RETURN:                                                               #
#         Only exits successfully (0).                                       #
#                                                                            #
#----------------------------------------------------------------------------#
help_message() {    
    echo "Usage: sh certificate-monitor.sh [-t][-d][-f]" 
    echo "    -t [target_email]: The target email (or target group email / alias)"
    echo "    -d [days_threshold]: The number of days used as a threshold"
    echo "    -f [filename]: The name of the file that contains the list of URLs"
    echo ""
    echo "How to run the script: "
    echo "    sh certificate-monitor.sh  -t <target_email> -d <days_threshold> -f <filename>"
    echo ""
    echo "Exs:"
    echo "    sh certificate-monitor.sh -t example@email.com -d 10 -f myfile.txt"
    echo "    sh certificate-monitor.sh -t aliasTarget@email.com -d 20 -f myURLs.txt"
    echo "    sh certificate-monitor.sh -t targetGroupt@email.com -d 30 -f urls.txt"
    exit $E_NORMERROR
}

#----------------------------------------------------------------------------#
#      read_input_file()                                                     #
#                                                                            #
#      Loops through each URL entry in the site-list.txt file.               #
#                                                                            #
#----------------------------------------------------------------------------#
read_input_file(){
    for i in $(cat $INPUT_FILE);do
        url=$i        
        check_expiring_date_for_certificates $url
    done
}

#----------------------------------------------------------------------------#
#      check_expiring_date_for_certificates()                                #
#                                                                            #
#      Checks the expiration date of a given url.                            #
#                                                                            #
#      PARAMETERS:                                                           #
#         $1: A URL string.                                                   #
#      RETURN:                                                               #
#         Exits with 0 if successful, otherwise exits unsuccessfully with a  #
#         non-zero value.                                                    #
#                                                                            #
#----------------------------------------------------------------------------#
check_expiring_date_for_certificates() {    
    expiration_string=$(echo | openssl s_client -servername $1 -connect $1:443 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -f2 -d=)
    if [ -z "$expiration_string" ]; then
        echo "Check of certificate for $1 failed" | systemd-cat -t "certificate-monitor" -p warning
        return
    fi
    expiration_date=$(date -d "$expiration_string" +%s)
    days_left="$(calculate_days_left)"
    if [ $days_left -ge $DAYS ]; then
        email_body+="Certificate for $1 expires in more than $DAYS days${NEW_LINE}"        
    else        
        email_body+="Time to renew certificate for $1! Right now it is less than $DAYS days for it to expire${NEW_LINE}"        
    fi
}

#----------------------------------------------------------------------------#
#      calculate_days_left()                                                 #
#                                                                            #
#      Calculates the number of days left until the certificate of the URL   #
#      under consideration expires.                                          #
#                                                                            #
#----------------------------------------------------------------------------#
calculate_days_left(){    
    days_left=$(( ($expiration_date-$TODAY)/(24*60*60) ))
    echo "$days_left"
}

#----------------------------------------------------------------------------#
#      send_email_to_target_group()                                          #
#                                                                            #
#      Sends an e-mail to the target group (or recipient).                   #
#                                                                            #
#      PARAMETERS:                                                           #
#         $1 -- Body of the e-mail, which represents its primary message.    #
#      RETURN:                                                               #
#         Exits with 0 if successful, otherwise it exits unsuccessfully with #
#         a non-zero value.                                                  #
#                                                                            #
#----------------------------------------------------------------------------#
send_email_to_target_group() {
    echo "Sending report email to target group..."    
    echo -e 'Subject:'"$EMAIL_SUBJECT"'\n\n'"$1"  | sendmail -v $TARGET_GROUP -F $EMAIL_SENDER
}

#----------------------------------------------------------------------------#
#      send_message_to_discord()                                             #
#                                                                            #
#      Sends a message to Discord.                                           #
#                                                                            #
#----------------------------------------------------------------------------#
send_message_to_discord() {   
    echo "Sending report message to discord channel..."       
    curl -X POST --data-urlencode "content=$1" $DISCORD_WEBHOOK_URL
}

#----------------------------------------------------------------------------#
#      MAIN - In here we invoke the defined methods in a logical order       #
#----------------------------------------------------------------------------#

# Processing the flags passed to the program
# In case of no arguments
if [ $# -eq "$NO_ARGS" ]
then
    normal_usage
    exit $E_OPTERROR
fi

# In case of -f -d -h and wrong flags
while getopts ":t:d:f:h" flag; do
    case "${flag}" in 
        t) TARGET_GROUP=${OPTARG};;
        d) DAYS=${OPTARG};;
        f) INPUT_FILE=${OPTARG};;
        h) help_message;;
        \?)
            wrong_parameters ${OPTARG}
            exit $E_NORMERROR   
    esac    
done

# Invoking the method to read the file that is passed as an argument
read_input_file
# Invoking the method to send the email with the result
send_email_to_target_group "$email_body"
# Invoking the method to send the message to discord
send_message_to_discord "$email_body"
# Exiting the program
exit $E_NORMERROR
