INSTALL_LOC=/usr/local/bin

function prep(){
    # Update and upggrade
    sudo apt update && sudo apt upgrade;
    # Build Install location
    mkdir $INSTALL_LOC/snort_src && cd $INSTALL_LOC/snort_src;
    sudo sudo apt install -y build-essential autotools-dev libdumbnet-dev libluajit-5.1-dev libpcap-dev libpcre3-dev zlib1g-dev pkg-config libhwloc-de;
    sudo apt install -y cmake;
    sudo apt install -y liblzma-dev openssl libssl-dev cpputest libsqlite3-dev uuid-dev;
    apt install -y libtool git autoconf;
    sudo apt install -y bison flex;

    wget \ >https://downloads.sourceforge.net/project/safeclib/libsafec-10052013.tar.gz
}

prep;

function prepSystem(){
    # Setup Install log Logfile
    logfile=/tmp/snort_install.log
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

function installLibsafe(){
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
    wget -q https://downloads.sourceforge.net/project/safeclib/libsafec-10052013.tar.gz
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

function installRagel(){
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

function installHyperscan(){
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

function installDAQ(){
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


function installSnort(){
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

    sudo ln -s /opt/snort/bin/snort /usr/sbin/snort
}