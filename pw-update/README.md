# Password Update

#Description
This script will check the password expiry and if the user password is about to expire in 7 days or lesser,
then update the password with a random alpha numeric value. 
If the mail command is enabeld in the server and mapped to a smtp server, then it will send out a notification email to the configured mail address 
the status whether it is success or failure.

#Details of the utility script
This contains 2 files
.pwdUpdate --> This is the file used to maintain the existing password --> need to give 640 file permission to hide from other users
password-update.sh --> This is the script file used to check and update the user password, need to give the execution permission to run this file

#Modification required
Variables to be updated in the script
EMAIL_TO_ADDRESS --> Add the mail address of the recepients to send the status 
PWD_FILE --> Update the FQDN of the file

Configure this script as a crontab to run every day or once in every 7 days

crontab -e
	Press i to go to the insert /edit mode
	Add the below
0 7 * * * <Path_to_script>/password-update.sh >/dev/null 2>&1

