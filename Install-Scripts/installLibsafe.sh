
function installLibsafe {
    logfile=/tmp/snort_install.libSafe.log

    ##########
    # Libsafe: Used to aviod buffer overflow issues when dealing with high volume. 
    ##########
    echo "\n\n########################\n###### Libsafe Install ######" >> $logfile;
    # Check if lib saf is installed in snort source directiory
    if [ -d ~/snort_src/libsafec-10052013/src/ ]
    then
    # Download the source and make/install it
    echo "\n\n### INSTALLING:\n\t ->-> Libsafe\n\n"
    echo "\n\n#### Libsafe Install ####\n" >>$logfile
    wget -q https://downloads.sourceforge.net/project/safeclib/libsafec-10052013.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fsafeclib%2Ffiles%2Flatest%2Fdownload&ts=1579754261;
    tar -xzf libsafec-10052013.tar.gz
    sudo rm libsafec-10052013.tar.gz
    cd libsafec-10052013
    ./configure >>$logfile
    make >>$logfile
    sudo make install >>$logfile;
    else
    echo "\n\t ----- SKIPPING .... \n\t ---> Libsafe is already installed.\n\n";
    fi
}

installLibsafe();