#!/bin/bash

# take the command line parameter and store it as an int in $packages
printf -v packages '%d\n' $* 2>/dev/null

let "val = $packages & 32"
if [ $val == '32' ]
    then
    echo "Checking for any system updates"
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    yum -y -q update
    echo "Updating GIT"
    yum -y -q remove git
    yum install -y -q https://centos7.iuscommunity.org/ius-release.rpm
    yum install -y -q git2u-all
fi

let "val = $packages & 1"
if [ $val == '1' ]
    then
    echo "Installing GNOME"
    yum -y -q groupinstall "GNOME Desktop" "Graphical Administration Tools"
    ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target
    echo "Installing VNC and RDP"
    yum -y -q install xrdp tigervnc-server
    sleep 0.5
    systemctl start xrdp
    systemctl enable xrdp
    echo "Opening RDP port in firewall" 
    firewalld
    sleep 0.5
    firewall-cmd --permanent --add-port=3389/tcp
    firewall-cmd --reload
    chcon --type=bin_t /usr/sbin/xrdp
    chcon --type=bin_t /usr/sbin/xrdp-sesman
fi

let "val = $packages & 2"
if [ $val == '2' ]
    then
    echo "Installing VS Code"
    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    yum -q check-update
    yum install -y -q code;
fi

let "val = $packages & 4"
if [ $val == '4' ]
    then
    echo "Installing Chromium"
    yum install -y -q chromium
fi

let "val = $packages & 8"
if [ $val == '8' ]
    then
    echo "Installing GoLang"
    yum install -y -q golang
fi

let "val = $packages & 16"
if [ $val == '16' ]
    then
    echo "Installing Docker"
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo -y -q install docker-ce
fi
