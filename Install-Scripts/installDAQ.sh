
function installDAQ {
    logfile=/tmp/snort_install.daq.log

    ##########
    # Data AcQuisition Library (DAQ)
    ##########

    if [ -f ~/snort_src/daq-2.2.2/libtool ];
    then
    echo "\n\n### INSTALLING:\n\t ->-> DAQ\n"
    echo "\n\n#### DAQ Install ####\n" >>$logfile
    cd ~/snort_src
    sudo wget -q https://www.snort.org/downloads/snortplus/daq-2.2.2.tar.gz
    tar -xzf daq-2.2.2.tar.gz
    sudo rm daq-2.2.2.tar.gz
    cd daq-2.2.2
    ./configure  >>$logfile
    make >>$logfile
    sudo make install > /dev/null 2>>$logfile
    sudo ldconfig >>$logfile
    else
    echo "\n---- SKIPPING ---- \n\t: DAQ is already installed.";
    fi
}

installDAQ();