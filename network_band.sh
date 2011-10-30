#! /bin/bash

# echo -e "\033[0;30m"       echo in black
# echo -e "\033[0;31m"       echo in red
# echo -e "\033[0;32m"       echo in green
# echo -e "\033[0;33m"       echo in yellow
# echo -e "\033[0;34m"       echo in blue
# echo -e "\033[0;35m"       echo in magenta
# echo -e "\033[0;36m"       echo in cyan
# echo -e "\033[0;37m"       echo in white

# echo -e "\033[4;37m"       echo in white underlined

# Print name of network service
echo -e "\033[4;33m" "Ethernet"

# Get ethernet status from OS X
Status=$(ifconfig en0 | awk '/status/ {print $2}')

# Check for network activity
if [ "$Status" = "inactive" ];
	
	# Inform user if not connected to ethernet network
	then echo -en "\033[0;31m" "Status: " $Status "\nNot connected to wired network.\n"
	
	# Inform user if connected to ethernet network
	else echo -e  "\033[0;32m" "Status" $Status
	
	# Get ethernet stats from OS X
	EthIP=$(networksetup -getinfo Ethernet | grep -v IPv6 | awk '/IP address/ {print $3}')
	EthSubMask=$(networksetup -getinfo Ethernet | grep -v IPv6 | awk '/Subnet mask/ {print $3}')
	LineSpeed=$(ifconfig en0 | awk '/media/ {print $3}' | sed 's/[^0-9]//g')
	
	# Get the current number of bytes in and bytes out
	myvar1=$(netstat -ib | grep -e en0 -m 1 | awk '{print $7}') #  bytes in
	myvar3=$(netstat -ib | grep -e en0 -m 1 | awk '{print $10}') # bytes out
	
	#Wait two seconds
	sleep 2
	
	# Get the number of bytes in and out one second later
	myvar2=$(netstat -ib | grep -e en0 -m 1 | awk '{print $7}') # bytes in again
	myvar4=$(netstat -ib | grep -e en0 -m 1 | awk '{print $10}') # bytes out again
	
	# Find the difference between bytes in and out during that one second
	subin=$(($myvar2 - $myvar1))
	subout=$(($myvar4 - $myvar3))
	
	# Convert bytes to megabytes
	mbin=$(echo "scale=2 ; $subin/1048576;" | bc)
	mbout=$(echo "scale=2 ; $subout/1048576;" | bc)
	
	mbUsed=$(echo "scale=2 ; $mbin+$mbout;" | bc)
	
	AvailBW=$(echo "scale=2 ; $LineSpeed-$mbUsed;" | bc)
	
	echo -e "\033[0;37m" "IP Address: " "\033[0;36m" $EthIP "\033[0;37m" "\nSubnet Mask: " "\033[0;36m" $EthSubMask 

		# Output bandwidth in Mbps and Gbps
		if [ "$LineSpeed" = "1000" ] ;
			then LineSpeed2=$(($LineSpeed/1000))
			echo -e "\033[0;37m" "Line Speed: " "\033[0;36m" $LineSpeed2 "Gbps"
			else echo -e "\033[0;37m" "Line Speed: " "\033[0;36m" $LineSpeed "Mbps"
			fi

		# Check for available Mbps and Gbps bandwidth 	
 		if [ "$AvailBW" = "1000" ];
			then AvailBW2=$(($AvailBW/1000))
			echo -e "\033[0;37m" "Available Bandwidth: " "\033[0;36m" $AvailBW2 "Gbps"
			else echo -e "\033[0;37m" "Available Bandwidth: " "\033[0;36m" $AvailBW "Mbps"
			fi
	echo -e "\033[0;37m" "Data In: "  "\033[0;36m" $mbin "Mbps" "\n" "\033[0;37m" "Data Out: "  "\033[0;36m" $mbout "Mbps"
fi
