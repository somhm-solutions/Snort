
function installRagel {
    logfile=/tmp/snort_install.rangel.log

    ##########
    # Ragel
    ##########
    cd ~/snort_src/
    ragel -v > /dev/null 2>&1
    result=$?
    if [ "$result" -eq 127 ];
    then
        # Download Ragel and make/install it
        echo "\n\n### INSTALLING:\n\t ->->  Ragel\n"
        echo "\n\n#### Ragel Install ####\n" >>$logfile
        cd ~/snort_src
        wget -q https://www.colm.net/files/ragel/ragel-6.9.tar.gz
        tar -xzf ragel-6.9.tar.gz
        sudo rm ragel-6.9.tar.gz
        cd ragel-6.9
        ./configure >>$logfile
        make >>$logfile
        sudo make install >>$logfile;
    else
        echo "\n---- SKIPPING ---- \n\t: Ragel is already installed.\n";
    fi
 }

 installRagel();