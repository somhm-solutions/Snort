

function installSnort {
    logfile=/tmp/snort_install.snort.log

    ##########
    # Snort
    ##########
    /opt/snort/bin/snort -V > /dev/null
    result=$?
    if [ "$result" != '0' ];
    then
    cd ~/snort_src
    wget -q https://github.com/snortadmin/snort3/archive/master.tar.gz
    tar -xzf master.tar.gz
    cd snort3-master/
    export my_path=/opt/snort
    sudo sh ./configure_cmake.sh --prefix=$my_path >>$logfile
    cd build
    make -j $(nproc) install >>$logfile
    # sudo make install >>$logfile
    else
    echo "\n---- SKIPPING ---- \n\t: Snort is already installed.";
    fi

    # Link Snort executable  
    sudo ln -s /opt/snort/bin/snort /usr/sbin/snort
}

installSnort();