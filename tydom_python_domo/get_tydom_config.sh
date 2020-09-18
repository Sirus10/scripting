# Just a simple way to get Tydom confi
#
# Step 1 collect data from Tydom
#python main.py get_configs_file |grep Tydom-00 > config.json
python main.py get_configs_file  > config.json


# Step x remove unreadable charracter for python
#sed -e 's/\\xc3\\xa0/a/g'  config.json > config.json1
#sed -e 's/\\xc3\\xa8/e/g'  config.json1 > config.json
#sed -e 's/\\xc3\\xa9/e/g'  config.json > config.json1
#sed -e 's/\\xc3\\xaa/e/g'  config.json1 > config.json
#sed -e 's/\\xc3\\xab/e/g'  config.json > config.json1

#sed -e 's/\\xc3\\x89/e/g'  config.json1 > config.json

#mv config.json1 config.json


# Step 2 make the information readable
#sed 's/r\\n\\r\\n/THISISTOCUT/g' config.json |awk -F  'THISISTOCUT' ' {print $2}'  |awk -F  "', rsv" ' {print $1}' |python -m json.tool > tydom.readable.json
#sed 's/r\\n\\r\\n/THISISTOCUT/g' config.json |awk -F  'THISISTOCUT' ' {print $2}'  |awk -F  "', rsv" ' {print $1}'  > tydom.readable.json
sed 's/{/\n{/g'  config.json |grep -v DEBUG > tydom.readable.json


# Step 3 display content
cat tydom.readable.json
