
function installHyperscan {
    logfile=/tmp/snort_install.hyperscan.log

    ##########
    # Hyperscan
    ##########
    cd ~/snort_src/hyperscan-4.2.0-build/ 2>&1
    ./bin/simplegrep "Hyperscan" hs_version.h > /dev/null 2>&1
    result=$?
    if [ "$result" != '0' ];
    then
    # Download Boost C++ for Hyperscan
    echo "\n\n### INSTALLING:\n\t ->->  Hyperscan\n"
    echo "\n\n#### Hyperscan Install ####\n" >>$logfile
    cd ~/snort_src
    sudo wget -q https://downloads.sourceforge.net/project/boost/boost/1.63.0/boost_1_63_0.tar.gz
    sudo tar -xzf boost_1_63_0.tar.gz
    sudo rm boost_1_63_0.tar.gz
    # Download and install Hypercscan
    cd ~/snort_src
    wget -q https://github.com/01org/hyperscan/archive/v4.2.0.tar.gz
    tar -xzf v4.2.0.tar.gz
    sudo rm v4.2.0.tar.gz
    mkdir ~/snort_src/hyperscan-4.2.0-build
    cd hyperscan-4.2.0-build/
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBOOST_ROOT=~/snort_src/boost_1_63_0/ ../hyperscan-4.2.0 >> $logfile
    make >>$logfile
    sudo make install >>$logfile;
    else
    echo "\n---- SKIPPING ---- \n\t: Hyperscan is already installed.";
    fi
}

installHyperscan();