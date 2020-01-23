

function prepSystem {
    # Setup Install log Logfile
    logfile=/tmp/snort_install.prepSystem.log
    echo "#### SNORT SETUP SCRIPT ####\n" > $logfile


    # Update and Upgrade
    echo "\n\n#### System updates and Upgrades  ####\n" >>$logfile
    sudo apt-get update -y || echo "Failed apt update"  >>$logfile
    sudo apt-get dist-upgrade -y || echo "Failed apt  upgrade" >>$logfile


    # Install prerequisites
    echo "\n\n#### Prerequisite Libraries and package installs  ####\n" >>$logfile
    sudo apt-get install -y build-essential autotools-dev libdumbnet-dev libluajit-5.1-dev libpcap-dev libpcre3-dev zlib1g-dev pkg-config libhwloc-dev cmake  liblzma-dev openssl libssl-dev cpputest  libtool git autoconf bison flex  || echo "Failed installing prequisites" >>$logfile

    # Create source directory
    mkdir -p ~/snort_src
    cd ~/snort_src
}

prepSystem();