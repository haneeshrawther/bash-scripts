# Password Update

#Description<br>
This script will check the password expiry and if the user password is about to expire in 7 days or lesser,then update the password with a random alpha numeric value. <br>
If the mail command is enabeld in the server and mapped to a smtp server, then it will send out a notification email to the configured mail address <br>
the status whether it is success or failure. <br> <br>

#Details of the utility script <br>
This contains 2 files <br>
.pwdUpdate --> This is the file used to maintain the existing password --> need to give 640 file permission to hide from other users <br>
password-update.sh --> This is the script file used to check and update the user password, need to give the execution permission to run this file <br><br>

#Modification required <br>
Variables to be updated in the script <br>
EMAIL_TO_ADDRESS --> Add the mail address of the recepients to send the status  <br>
PWD_FILE --> Update the FQDN of the file <br> <br>

Configure this script as a crontab to run every day or once in every 7 days <br> <br>

crontab -e <br>
	Press i to go to the insert /edit mode <br>
	Add the below <br>
0 7 * * * <Path_to_script>/password-update.sh >/dev/null 2>&1 <br>

