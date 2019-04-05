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

echo "Perform first time setup? Choose option 1 or 2"
select yn in "Yes" "No"; do
    case $yn in
        Yes )
            let "packages = $packages + 32"
            break
            ;;
        No )
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

echo "Do you wish to install Docker? Choose option 1 or 2"
select yn in "Yes" "No"; do
    case $yn in
        Yes )
            let "packages = $packages + 16"
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

installerpath="/srv/installers.sh"
cp "./installers.sh" $installerpath
sudo chmod +x $installerpath

sudo -u $varname sudo $installerpath $packages

rm $installerpath

echo "Completed setup."
