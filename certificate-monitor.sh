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
INPUT_FILE="site-list.txt"



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
#      send_email_to_group_target()                                          #
#                                                                            #
#      TO DO -> ADD COMMENTS LATER                                           #
#                                                                            #
#----------------------------------------------------------------------------#
send_email_to_group_target() {
    echo 'This method should use the smtp server to send an email to the target group'
    echo 'The message that will be sent is received from the method check_expiring_date_for_certificates'
}




#----------------------------------------------------------------------------#
#      MAIN - In here we invoke the defined methods in a logical order       #
#----------------------------------------------------------------------------#
read_input_file