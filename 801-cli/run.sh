wpa_supplicant -B -D wired -i enp1s0 -dd -c wpa.conf #Replace eth0 with your ethernet interface, add -B if you want to run it as a daemon in the background
dhclient -r
