pass Mail/bungert@stud.uni-heidelberg.de | sudo openconnect \
    vpn-ac.urz.uni-heidelberg.de -u tz425 --passwd-on-stdin \
    -s 'vpn-slice 129.206.10.0/24' -b &> /dev/null
