#!/bin/bash
#
##################################################################################################################
#
# Информация к размышлению      :   Скрипт используется для слежки за вами, и последующего траха вас в анал
# 
# По воопросам и предложениям   :   https://wwh-club.net/members/crowe.51568/
#
##################################################################################################################
#
##################################################################################################################
#
#           НИЧЕГО НЕ МЕНЯЙТЕ В СКРИПТЕ НУ ТОЛЬКО ГДЕ РАЗРЕШЕНО ОНЛИ, А ТО СУКА БУДЕТЕ ВЫЕБАНЫ В ЖОПУ :)
#
##################################################################################################################

# Обновление
echo -n "Вы хотите запустить процесс удаления неиспользуемых пакетов и обновления системы (y/N)?"; read s
if [ "$s" != "y" ]; then
        echo "Очень жаль";
else
        echo "Процедура запущен :)"
        sudo apt-get autoremove && sudo apt-get update && sudo apt-get -y dist-upgrade;
fi


sudo apt-get install -y subversion build-essential bcc iasl xsltproc uuid-dev \
    zlib1g-dev libidl-dev libsdl1.2-dev libxcursor-dev libasound2-dev \
    libstdc++5 libpulse-dev libxml2-dev libxslt1-dev pyqt5-dev-tools \
    libqt5opengl5-dev qtbase5-dev-tools libcap-dev libxmu-dev \
    mesa-common-dev libglu1-mesa-dev linux-libc-dev libcurl4-openssl-dev \
    libpam0g-dev libxrandr-dev libxinerama-dev libqt5opengl5-dev makeself \
    libdevmapper-dev default-jdk texlive-latex-base texlive-latex-extra \
    texlive-latex-recommended texlive-fonts-extra texlive-fonts-recommended \
    lib32ncurses5 lib32z1 libc6-dev-i386 lib32gcc1 gcc-multilib \
    lib32stdc++6 g++-multilib genisoimage libvpx-dev qt5-default \
    qttools5-dev-tools libqt5x11extras5-dev libssl-dev python-all-dev \
    git-svn kbuild iasl libpng-dev libsdl-dev yasm
    
svn co http://www.virtualbox.org/svn/vbox/trunk vbox
chmod +x patch-vbox.sh obfuscate.sh
cp patch-vbox.sh vbox/patch-vbox.sh
cp -R vbox vbox-kopiya
cd vbox


# update
echo -n "Открой файл patch-vbox.sh текстовым редактором и измени user на свое имя в системе, и так же посмотри 1-й пункт в Readme.md, после изменений сохраняйтесь и нажимайте Y, для отмены нажимайте N (y/N)?"; read s
if [ "$s" != "y" ]; then
        echo "Очень жаль";
else
        echo "Переходим к созданию дистрибутива с последующей установкой"
    chmod +x patch-vbox.sh
        ./patch-vbox.sh;
fi
