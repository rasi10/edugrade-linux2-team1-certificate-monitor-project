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

#----------------------------------------------------------------------------#
#      Global constants, global variables, set options, etc                  #
#----------------------------------------------------------------------------#
set -e

NO_ARGS=0
E_OPTERROR=85

unset INPUT_FILE
unset DAYS

#----------------------------------------------------------------------------#
#      normal_usage()                                                        #
#                                                                            #
#      TO DO -> ADD COMMENTS LATER                                           #
#                                                                            #
#----------------------------------------------------------------------------#
normal_usage() {
    echo "Usage: sh certificate-monitor.sh [-f] [-d]" 
    echo "    -f [filename]: The name of the file that contains the list of URLs"
    echo "    -d [days]: The number of days used as a threshold"
    echo ""
    echo "Run 'sh certificate-monitor.sh -h' for help" 

}

#----------------------------------------------------------------------------#
#      wrong_parameters()                                                    #
#                                                                            #
#      TO DO -> ADD COMMENTS LATER                                           #
#                                                                            #
#----------------------------------------------------------------------------#
wrong_parameters() {
    echo "Invalid flag/parameter: $1" 
    echo "Run 'sh certificate-monitor.sh -h' for help" 
}

#----------------------------------------------------------------------------#
#      help_message()                                                        #
#                                                                            #
#      TO DO -> ADD COMMENTS LATER                                           #
#                                                                            #
#----------------------------------------------------------------------------#
help_message() {    
    echo "Usage: sh certificate-monitor.sh [-f] [-d]" 
    echo "    -f [filename]: The name of the file that contains the list of URLs"
    echo "    -d [days]: The number of days used as a threshold"
    echo ""
    echo ""
    echo "Ex 1: sh certificate-monitor.sh -f myfile.txt -d 10" 
    echo "Ex 2: sh certificate-monitor.sh -f myfile.txt -d 20" 
    echo "Ex 3: sh certificate-monitor.sh -f myfile.txt -d 30" 
}

#----------------------------------------------------------------------------#
#      read_input_file()                                                     #
#                                                                            #
#      TO DO -> ADD COMMENTS LATER                                           #
#                                                                            #
#----------------------------------------------------------------------------#
read_input_file(){
    for i in $(cat $INPUT_FILE);
    do
        url=$i
        echo $url
    done    

    echo 'This method should return an array with the values stored in the file'
}

#----------------------------------------------------------------------------#
#      check_expiring_date_for_certificates()                                #
#                                                                            #
#      TO DO -> ADD COMMENTS LATER                                           #
#                                                                            #
#----------------------------------------------------------------------------#
check_expiring_date_for_certificates() {
    echo 'this method takes in an array as parameter and returns a string which is the body of the email'
    echo 'In here we should use openssl to build this information and use a function to calculate how many days'
}

#----------------------------------------------------------------------------#
#      calculate_days_left()                                                 #
#                                                                            #
#      TO DO -> ADD COMMENTS LATER                                           #
#                                                                            #
#----------------------------------------------------------------------------#
calculate_days_left(){
    echo 'this method should calculate how many days are left for one certificate to expire'
}

#----------------------------------------------------------------------------#
#      send_email_to_target_group()                                          #
#                                                                            #
#      TO DO -> ADD COMMENTS LATER                                           #
#                                                                            #
#----------------------------------------------------------------------------#
send_email_to_target_group() {
    echo 'This method should use the smtp server to send an email to the target group'
    echo 'The message that will be sent is received from the method check_expiring_date_for_certificates'
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
while getopts ":f:d:h" flag; do
    case "${flag}" in 
        f) INPUT_FILE=${OPTARG};; 
        d) DAYS=${OPTARG};;
        h) help_message;;
        \?)
            wrong_parameters ${OPTARG}
            exit 0       
    esac    
done

# Invoking the method to read the file that was passed as an argument
read_input_file