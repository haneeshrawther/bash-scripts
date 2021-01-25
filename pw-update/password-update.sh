#!/bin/sh

#add the mail address with space seperated if there are mutiple mail address
EMAIL_TO_ADDRESS="abc@gmail.com"

#Verify and update the file path if it is placed in a different location
PWD_FILE=$HOME/scripts/.pwdUpdate

error_exit()
{
        echo "error_exit --> $1" 1>&2
        mail_on_failure
        exit
}

mail_on_success(){

        mailSubject="ALERT:(PasswdExpiry-AutoUpdate-$USER@$HOSTNAME) ACTIONED !!!"
        mailBody="
Hi Team,

Please note that Password is about to expire in $expday days for the user $USER@$HOSTNAME.
Hence the same is updated as an automated process. Please note the below new password and update the same in your KEEPASS.

=============================================================================
                Server:$HOSTNAME
                USER:$USER
                New PassWord:$NewPassStr
=============================================================================

        "

        echo "
$mailSubject"
        echo "$mailBody">mailBody

        # mail -s "$mailSubject" MercatorTechDeliveryCargo@accelya.com MercatorCMOps@mercator.com  < $mailBody
        mail -s "$mailSubject" "$EMAIL_TO_ADDRESS" < mailBody; rm mailBody

}

mail_on_failure(){
        mailSubject="ALERT:(PasswdExpiry-AutoUpdate-$USER@$HOSTNAME) FAILED !!! - Manual ACTION Required"
        mailBody="
Hi Team,

Please note that Password Auto Update is failed for the user $USER@$HOSTNAME.
Hence please update the same manually ASAP.

        "

        echo "
$mailSubject"
        echo "$mailBody">mailBody

        mail -s "$mailSubject" "$EMAIL_TO_ADDRESS"  < mailBody; rm mailBody

}

currentdate=`date +%s`
userexp=`chage -l $USER|grep "Password expires" |cut -d: -f2`
passexp=`date -d "$userexp" +%s`
exp=`expr $passexp - $currentdate`
expday=`expr \( $exp / 86400 \)`

random=`date +%s%N |sha256sum| head -c8`
special_character=$(echo '!@#$&' | fold -w1 | shuf | head -c1)
special_character2=$(echo 'AQWSDERFGTYHJUIKOLP' | fold -w1 | shuf | head -c1)

counter=`grep "counter" $PWD_FILE|cut -d'=' -f 2|head -1`
currPass=`grep "currPass" $PWD_FILE|cut -d'=' -f 2|head -1`

echo "
currentdate=$currentdate
userexp=$userexp
expday=$expday
passexp=$passexp
exp=$exp
"

#If the password to be updated 
if [ "$expday" -le 7 ]; then
        echo "counter --> $counter"
        NewPassStr="$random$special_character$special_character2"
        echo "$currPass"
        echo "$NewPassStr"
        val=`echo -e "$currPass\n$NewPassStr\n$NewPassStr" | passwd || error_exit $val`
        echo "$val"
        if [[ $val == *"all authentication tokens updated successfully"* ]]; then
            echo "It's there!"
            mail_on_success
            echo "counter=1
currPass=$NewPassStr" > $PWD_FILE
        fi
fi

