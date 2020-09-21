#
# Just a simple way to play with tydom main.py file
#
# You can use same arguiment than in main.py
# The only difference is a status.txt file willbe generated each time 
# This file can be used to update domoticz for exemple
#
#  Usage : 
#   Only get latest update from devices : 
#   ./manage_tydom.sh
#   
#   Send action to Tydom 
#    Ex1 : move device 1234123 to 10%
#    ./manage_tydom.sh put_devices_data 1234123 10
#
#	

# Step 1 Run the command
python main.py $1 $2 $3 $4 >  config.json


# Step 3 Merge config/status generated
echo "UPDATE : `date`" > status.txt
grep -v DEB config.json >> status.txt


# Step x Display the file / just for fun
cat status.txt
