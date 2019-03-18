#!/bin/bash

# set up a variable to hold values of what packages to install
let "packages = 0"

echo "Do you need to set up a user? Choose option 1 or 2"
select yn in "Yes" "No"; do
    case $yn in
        Yes)
            echo Enter your username
            read varname; useradd $varname
            passwd $varname
            usermod -aG wheel $varname
            break
            ;;
        No)
            break
            ;;
    esac
done

echo "Do you wish to install GNOME? Choose option 1 or 2"
select yn in "Yes" "No"; do
    case $yn in
        Yes )
            let "packages = $packages + 1"
            echo "Do you wish to install VS Code? Choose option 1 or 2"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes )
                        let "packages = $packages + 2"
                        break
                        ;;
                    No )
                        break
                        ;;
                esac
            done

            echo "Do you wish to install Chromium? Choose option 1 or 2"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes )
                        let "packages = $packages + 4"
                        break
                        ;;
                    No )
                        break
                        ;;
                esac
            done
            break
            ;;
        No )
            break
            ;;
    esac
done

echo "Do you wish to install GoLang? Choose option 1 or 2"
select yn in "Yes" "No"; do
    case $yn in
        Yes )
            let "packages = $packages + 8"
            break
            ;;
        No )
            break
            ;;
    esac
done

echo "Checking for any system updates"
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y update

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

echo "Completed setup."
