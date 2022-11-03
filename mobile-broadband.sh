# SCRIPT BEBINGS FROM HERE
#!/bin/bash

# To get the connection name (id) and connection uuid, execute the following command
# nmcli -p con
# Replace defaultConnection and defaultConnectionsUUID with your own settings 

defaultConnection="Dialog GSM Postpaid"
defaultConnectionsUUID=daad515c-b1e7-4a5c-a139-669a1d28304a

interval=2

case "$1" in

start) 
	echo "Starting the mobile broadband connection: " $defaultConnection " (UUID - " $defaultConnectionsUUID ")"
	while true; do
		LC_ALL=C nmcli -t -f TYPE,STATE dev | grep -q "^gsm:disconnected$"
		if [ $? -eq 0 ]; then
			echo "Device Found: " $defaultConnection
            		break
       			else
			echo "Device is not found. Retrying in " $interval " seconds."
			sleep $interval

		fi
	done
	echo "Starting Wireless WAN"
	nmcli -t nm wwan on
	echo "Connecting " $defaultConnection  
	nmcli -t con up uuid $defaultConnectionsUUID
	echo "Done!"
;;

stop)
	echo "Stopping the mobile broadband connection: " $defaultConnection " (UUID - " $defaultConnectionsUUID ")"
      	nmcli -t con down uuid $defaultConnectionsUUID
	echo "Stopping Wireless WAN"
      	nmcli -t nm wwan off
	echo "Successfully Disconnected"

;;
status)
	LC_ALL=C nmcli -t -f TYPE,STATE dev | grep -q "^gsm:disconnected$"
	if [ $? -eq 0 ]; then
		echo "Device not found or GSM disconnected"
	else 
		echo "GSM Connected"
	fi

;;
*)
  	echo "Mobile Broadband Startup Service"
      	echo $"Usage: $0 {start|stop|status}"
	echo ""
	echo "IMPORTANT!"
 	echo "Edit this script to replace the values for defaultConnection and defaultConnectionsUUID with your gsm connection details"
	echo "We found the following Connections list (ONLY GSM TYPE) for your system"
	echo "=================================="
	echo "Connection list"
	echo "=================================="
	echo "ID UUID TYPE"                                  
	echo "----------------------------------"
	nmcli -p -f NAME,UUID,TYPE con | grep gsm
      	exit 1
esac
exit 0
		

# SCRIPT ENDS HERE
