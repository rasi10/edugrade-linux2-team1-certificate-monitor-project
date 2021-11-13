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

email_body=""
unset INPUT_FILE
unset DAYS
unset TARGET_GROUP


#----------------------------------------------------------------------------#
#      normal_usage()                                                        #
#                                                                            #
#      TO DO -> ADD COMMENTS LATER                                           #
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
#      TO DO -> ADD COMMENTS LATER                                           #
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
#      TO DO -> ADD COMMENTS LATER                                           #
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
#      TO DO -> ADD COMMENTS LATER                                           #
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
#      TO DO -> ADD COMMENTS LATER                                           #
#                                                                            #
#----------------------------------------------------------------------------#
check_expiring_date_for_certificates() {    
    expiration_string=$(echo | openssl s_client -servername $1 -connect $1:443 2>/dev/null | openssl x509 -noout -enddate | cut -f2 -d=)
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
#      TO DO -> ADD COMMENTS LATER                                           #
#                                                                            #
#----------------------------------------------------------------------------#
calculate_days_left(){    
    days_left=$(( ($expiration_date-$TODAY)/(24*60*60) ))
    echo "$days_left"
}

#----------------------------------------------------------------------------#
#      send_email_to_target_group()                                          #
#                                                                            #
#      TO DO -> ADD COMMENTS LATER                                           #
#                                                                            #
#----------------------------------------------------------------------------#
send_email_to_target_group() {
    echo "Sending report email to target group..."    
    echo -e 'Subject:'"$EMAIL_SUBJECT"'\n\n'"$1"  | sendmail -v $TARGET_GROUP -F $EMAIL_SENDER
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
# Exiting the program
exit $E_NORMERROR
