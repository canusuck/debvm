#!/bin/bash
#
##################################################################################################################
# Информация к размышлению      :   Скрипт используется для слежки за вами, и последующего траха вас в анал
# 
# По воопросам и предложениям   :   https://wwh-club.net/members/crowe.51568/
##################################################################################################################
##################################################################################################################
#
#           НИЧЕГО НЕ МЕНЯЙТЕ В СКРИПТЕ НУ ТОЛЬКО ГДЕ РАЗРЕШЕНО ОНЛИ, А ТО СУКА БУДЕТЕ ВЫЕБАНЫ В ЖОПУ :)
#
##################################################################################################################
#
# Каталоги и имена файлов
SOURCESDIR=/home/user/sources/vbox                                  # Директория где находится исходный код VirtualBox 
KMKTOOLSSUBDIR=kBuild/bin/linux.amd64                               # Где находится инструменты kmk например kmk_md5sum
MD5SUMOUT=$SOURCESDIR/kmk_md5.out                                   # Лог md5sum к этому файлу
VBOXMANAGE=$SOURCESDIR/out/linux.amd64/release/bin/VXoxManage       # Местоположение и имя двоичного файла VBoxManage (после переименования)

# Подозрительные строки для переименования, например. «VirtualBox» переименовывается в «XirtualXox» (без пробелов, одинаковой длины!)
VirtualBox=XirtualXox
virtualbox=xirtualxox
VIRTUALBOX=XIRTUALXOX
virtualBox=xirtualXox
vbox=vxox
Vbox=Vxox
VBox=VXox
VBOX=VXOX
Oracle=Xracle
oracle=xracle
innotek=xnnotek
InnoTek=XnnoTek
INNOTEK=XNNOTEK
PCI80EE=80EF
PCI80ee=80ef

# Установка параметров для приложения VirtualBox
USRNAME=user                                            # Имя пользователя для запуска VirtualBox
IP=192.168.56.1                                         # IP интерфейс для VirtualBox в /etc/network/interfaces
NETMASK=255.255.255.0                                   # Маска для интерфейса VirtualBox
NETWORK=192.168.56.0                                    # Сетевой интерфейс для VirtualBOx
BROADCAST=192.168.56.255                                # Показ локального адреса для VirtualBox

# Запуск некоторых материалов установки ...
logfile="$(basename -s ".sh" $0).out"

# Создаем специальную функцию _echo для вывода
exec 3>&1
_echo () {
    echo "$@" >&3
}

# Все остальные stdout и stderr в /dev/null
exec &> ./$logfile

me="$(basename $0)"
count=0
# Переименование файлов и папок по типу arg1=string in filename to search for, arg2=string to rename filename to
function rename_files_and_dirs {
    _echo "[*]Replacing string \"$1\" to \"$2\" in all filenames"
    a=0
    false
    while [ $? -ne 0 ]; do a=`expr $a + 1`;
        find . -name "*$1*" ! -name $me ! -name $logfile -exec bash -c "mv \"\$0\" \"\${0/$1/$2}\"" {} \;
    done;
}

function replace_strings {
    count=`expr $count + 1`
    _echo -n "$count/15 "
    _echo "[*]Replacing string \"$1\" with string \"$2\" in all files. Be patient this takes a while (~35sec on my box)..."
    find . -type f ! -name $me ! -name $logfile -exec sed -i "s/$1/$2/g" {} +
}


# ----------- Главное ------------
_echo
_echo "[*] !!! ---- ПРОЧИТАЙТЕ ЭТО ПЕРЕД ИСПООЛЬЗОВАНИЕМ СКРИПТА ---- !!!"
_echo "[*] Эти скрипты исправляют код доступа vbox, компилируют его и, наконец, устанавливают приложение VirtualBox"
_echo "[*] Запустите этот скрипт как пользователь, который должен использовать приложение VirtualBox позже"
_echo "[*] Убедитесь, что вы находитесь в каталоге исходного кода vbox (то же самое, что и скрипт configure)"
_echo "[*] Этот скрипт был протестирован, шучу, не протестирован :)"
_echo "[*] Он приходит, как есть, он не делает слишком много проверки ошибок и т. д., если он не работает, исправьте его, желаю удачи :)"
_echo
_echo "[*] !!! УБЕДИТЕСЬ, ЧТО ВЫ ИЗМЕНИЛИ ПЕРЕМЕННЫЕ В заголовке этого скрипта перед продолжением (имя пользователя, каталоги и т.д.) !!!"
_echo

if [ -d $SOURCESDIR ]; then
        cd $SOURCESDIR
else
    _echo "[ОШИБКА] Вы изменили переменные в файле (см. Выше)? SOURCEDIR не существует. Процесс прерван.."
    exit 1
fi

if [ ! -f configure ] || [ ! -f Maintenance.kmk ]; then
    _echo "[ОШИБКА] Вы находитесь в неправильном каталоге. Процесс прерван.."
    exit 1
fi

if [ "$EUID" -eq 0 ]; then
    _echo -n "[ПРЕДУПРЕЖДЕНИЕ] Не запускайте этот скрипт от root (суперпользователя) Я не знаю работает ли это. Хотите продолжить (y/N)?"; read s
    if [ "$s" != "y" ]; then
        _echo "Хорошо, ничего не сделано. Процесс прерван..";
        exit 1
    fi
fi


# Настройка и компиляция исходного кода из первоночального состояния (это необходимо для того, чтобы скрипт работал!)
_echo -n "[*] Вы хотите начать процесс коомплиции и настройки исходного кода (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    _echo "[*] Начинаем настройку исходного кода."
    ./configure --disable-hardening >&3
    source $SOURCESDIR/env.sh
fi

_echo -n "[*] Вы хотите начать компиляцию исходного кода (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    _echo "[*] Запускаем процесс компилиции исходного кода. Это займет какое-то время. Вы можете пока выпить кружечку кофе.."
    kmk >&3
fi

_echo -n "[*] Вы хотите начать компиляцию модуля ядра (kernel modules) (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    _echo "[*] Запускаем процесс коомпиляции модуля ядра (kernel modules)"
    cd $SOURCESDIR/out/linux.amd64/release/bin/src/
    make >&3
fi

# Исправления прав и очистка
_echo -n "[*] Хотите начать очистку и исправления прав доступа (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    _echo "[*] Запускаем процесс исправления прав доступа и очистки"
    cd $SOURCESDIR
    source ./env.sh
    kmk clean
    sudo chown -R $USER:$(id -gn) *
    sudo chown -R $USER:$(id -gn) .*
fi

# Переименование файлов
_echo -n "[*] Хотите начать переименования файлов (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    _echo "[*] Создание лога в $logfile"

    # Переименование файлов и папок
    rename_files_and_dirs VirtualBox $VirtualBox
    rename_files_and_dirs virtualbox $virtualbox
    rename_files_and_dirs vbox $vbox
    rename_files_and_dirs VBox $VBox
    rename_files_and_dirs Oracle $Oracle
    rename_files_and_dirs oracle $oracle
fi

# Замена строк
_echo -n "[*] Хотите мы начнем изменения "подозрительных" строк для антидетекта VirtualBox (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    _echo "[*] Запускаем процесс замены строк. Потребуется примерно 15 циклов. Это заняло 15-20 минут на моей машине так что можете опять идти за кофе.."
    replace_strings VirtualBox $VirtualBox
    replace_strings virtualbox $virtualbox
    replace_strings VIRTUALBOX $VIRTUALBOX
    replace_strings virtualBox $virtualBox
    replace_strings vbox $vbox
    replace_strings Vbox $Vbox
    replace_strings VBox $VBox
    replace_strings VBOX $VBOX
    replace_strings Oracle $Oracle
    replace_strings oracle $oracle
    replace_strings innotek $innotek
    replace_strings InnoTek $InnoTek
    replace_strings INNOTEK $INNOTEK
    replace_strings 80EE $PCI80EE
    replace_strings 80ee $PCI80ee
fi

# замена параметра даты в BIOS
_echo -n "[*] Хотите начать замену параметра даты в BIOS (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    _echo "[*] Запускаем процесс замены параметра даты в BIOS"
    sed -i 's/06\/23\/99/07\/24\/13/g' $SOURCESDIR/src/VXox/Devices/PC/BIOS/orgs.asm
fi

# Начинаем настройку исходного кода
_echo -n "[*] Хотите начать настройку исходного кода (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    ./configure --disable-hardening >&3
    source $SOURCESDIR/env.sh
fi

# исправить неправильно переименованнх строк и функций в среде разработке QT
_echo -n "[*] Хотите запустить процесс исправления функций и методов в среде разработке QT (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    replace_strings QVXoxLayout QVBoxLayout
fi

# исправляем проверку BIOS MD5sum с помощью фейкоового MD5sum
_echo -n "[*] Хотите мы начнем исправление сгенерированной даты BIOS (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    _echo "[*] Запускаем процесс замены инструментов kmk_md5 нашей версией для исправления проверки BIOS"
    if [ -e "$SOURCESDIR/$KMKTOOLSSUBDIR/kmk_md5sum" ]; then
        mv $SOURCESDIR/$KMKTOOLSSUBDIR/kmk_md5sum $SOURCESDIR/$KMKTOOLSSUBDIR/kmk_md5sum.bak
        cat > $SOURCESDIR/$KMKTOOLSSUBDIR/kmk_md5sum <<- EOF
        #!/bin/bash
        echo \$2 >>$MD5SUMOUT
        echo \$2
        echo
EOF
        chmod +x $SOURCESDIR/$KMKTOOLSSUBDIR/kmk_md5sum
    else
        _echo "[ОШИБКА] Файл \"$SOURCESDIR/$KMKTOOLSSUBDIR/kmk_md5sum\" не найден"
        exit 1
    fi
fi

# Компиляция материала 
_echo -n "[*] Хотите запустить процесс компиляции исправленного исходного кода (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    _echo "[*] Запускаем процоесс компиляции исходного кода. Это займет какое-то время. Вы можете пока выпить кружечку кофе.."
    kmk >&3
fi

# Обновление даты BIOS снова (дата BIOS добавляется автоматически из файла
_echo -n "[*] Хотите начать процесс исправления другой даты BIOS (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    _echo "[*] Исправлена дата BIOS в автоматизированных файлах"
    _echo "[*] Файл: out/linux.amd64/release/obj/PcBiosBin/PcBiosBin286.c"
    sed -i 's/06\.23\.99/07\.24\.13/g' $SOURCESDIR/out/linux.amd64/release/obj/PcBiosBin/PcBiosBin286.c
    sed -i 's/0x30\, 0x36\, 0x2f\, 0x32\, 0x33\, 0x2f\, 0x39\, 0x39/0x30\, 0x37\, 0x2f\, 0x32\, 0x34\, 0x2f\, 0x31\, 0x32/g' out/linux.amd64/release/obj/PcBiosBin/PcBiosBin286.c >&3

    _echo "[*] Файл: out/linux.amd64/release/obj/PcBiosBin/PcBiosBin386.c"
    sed -i 's/06\.23\.99/07\.24\.13/g' $SOURCESDIR/out/linux.amd64/release/obj/PcBiosBin/PcBiosBin386.c
    sed -i 's/0x30\, 0x36\, 0x2f\, 0x32\, 0x33\, 0x2f\, 0x39\, 0x39/0x30\, 0x37\, 0x2f\, 0x32\, 0x34\, 0x2f\, 0x31\, 0x32/g' out/linux.amd64/release/obj/PcBiosBin/PcBiosBin386.c >&3

    _echo "[*] Файл: out/linux.amd64/release/obj/PcBiosBin/PcBiosBin8086.c"
    sed -i 's/06\.23\.99/07\.24\.13/g' $SOURCESDIR/out/linux.amd64/release/obj/PcBiosBin/PcBiosBin8086.c
    sed -i 's/0x30\, 0x36\, 0x2f\, 0x32\, 0x33\, 0x2f\, 0x39\, 0x39/0x30\, 0x37\, 0x2f\, 0x32\, 0x34\, 0x2f\, 0x31\, 0x32/g' out/linux.amd64/release/obj/PcBiosBin/PcBiosBin8086.c >&3

    _echo "[*] Повторная компиляция файлов BIOS."
    kmk >&3
fi

# Компиляция модулей ядра (kernel modules)
_echo -n "[*] Хотите начать процесс компиляции модулей ядра (kernel modules) (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    _echo "[*] Запускаем процесс компиляции модулей ядра (kernel modules)"
    cd $SOURCESDIR/out/linux.amd64/release/bin/src/
    make
fi

# Установка модулей ядра (kernel modules)
_echo -n "[*] Хотите начать процесс установки модулей ядра (kernel modules) (y/N)?"; read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    _echo "[*] Запускаем процесс установки модулей ядра (kernel modules)"
    sudo make install
fi

_echo "[*] Компиляция исходного кода завершена."


# -------- Установка Virtual Box ---------

_echo -n "[*] Хотите начать процесс установки VirtualBox на этом компьютере (y/N)?"; read s
if [ "$s" != "y" ]; then _echo "...выход. Ничего не сделано."; exit 1; fi

cd $SOURCESDIR/out/linux.amd64/release/bin

# Take care of kernel modules
if [ "$(lsmod | grep vxox)" ]; then
    _echo "[*] vxox модули ядра уже загружены. Выгружаем их..."
    sudo rmmod vxoxpci
    sudo rmmod vxoxnetflt
    sudo rmmod vxoxnetadp
    sudo rmmod vxoxdrv
fi

_echo "[*] Загрузка vxox модулей ядра"
sudo modprobe vxoxdrv
sudo modprobe vxoxnetflt
sudo modprobe vxoxnetadp
sudo modprobe vxoxpci

_echo "[*] Загруженные модули:"
lsmod | grep vxox

_echo -n "Хотите мы продолжим настройку автозагрузки vbox модулей через /etc/modules [y/N]"
read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    _echo "[*] Adding modules to /etc/modules"
    echo 'vxoxdrv'    | sudo tee --append /etc/modules > /dev/null
    echo 'vxoxpci'    | sudo tee --append /etc/modules > /dev/null
    echo 'vxoxnetadp' | sudo tee --append /etc/modules > /dev/null
    echo 'vxoxnetflt' | sudo tee --append /etc/modules > /dev/null
fi

# Копирование файлов в директории USR
_echo -n "Хотите мы запустим процесс Копирования файлов в директорию /usr/local/virtualbox [y/N]"
read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    if [ -e "/usr/local/virtualbox" ]; then
        _echo "Удаление старой директории /usr/local/virtualbox"
        sudo rm -rf /usr/local/virtualbox
    fi
    sudo mkdir /usr/local/virtualbox
    _echo "Копирование исполняемых файлов /usr/local/virtualbox"
    sudo cp -prf $SOURCESDIR/out/linux.amd64/release/bin/*    /usr/local/virtualbox/
    _echo "Копирование общих библиотек в /usr/lib/"
    sudo cp -prf $SOURCESDIR/out/linux.amd64/release/bin/*.so /usr/lib/
    _echo "Создание некоторых ссылок, например, XirtualXox to VirtualBox"
    if [ ! -e "/usr/local/bin/VirtualBox" ]; then sudo ln -s /usr/local/virtualbox/XirtualXox  /usr/local/bin/VirtualBox; fi
    if [ ! -e "/usr/local/bin/VBoxSVC"    ]; then sudo ln -s /usr/local/virtualbox/VXoxSVC     /usr/local/bin/VBoxSVC;    fi
    if [ ! -e "/usr/local/bin/VBoxManage" ]; then sudo ln -s /usr/local/virtualbox/VXoxManage  /usr/local/bin/VBoxManage; fi
fi

# создание пользователей / групп и разрешений на устройства Vbox
_echo -n "Хотите мы создадим группу vboxusers и установим права доступа /dev/vxox (y/N)"
read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано.";
else
    sudo groupadd vboxusers
    sudo usermod -G vboxusers -a $USRNAME
    sudo chmod 660 /dev/vxox*
    sudo chgrp vboxusers /dev/vxox*
fi

# Настройка группы пользователей для устройств Vbox при запуске
_echo -n "Хотите мы продолжить настройку устройств vbox в /etc/udev/rules.d/40-permissions.rules [y/N]?"
read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано."
else
    if [ -e "/etc/udev/rules.d/40-permissions.rules" ]; then
        sudo cp /etc/udev/rules.d/40-permissions.rules /etc/udev/rules.d/40-permissions.rules.vboxinstaller.bak
    fi

    _echo "[*] Добавляем девайс в /etc/udev/rules.d/40-permissions.rules"
    echo 'KERNEL=="vxoxdrv",                        GROUP="vboxusers", MODE="0660"' \
        | sudo tee --append /etc/udev/rules.d/40-permissions.rules > /dev/null
    echo 'KERNEL=="vxoxdrv",                        GROUP="vboxusers", MODE="0660"' \
        | sudo tee --append /etc/udev/rules.d/40-permissions.rules > /dev/null
    echo 'KERNEL=="vxoxdrvu",                       GROUP="vboxusers", MODE="0660"' \
        | sudo tee --append /etc/udev/rules.d/40-permissions.rules > /dev/null
fi

# Создание сетевого интерфейса
_echo "Эти виртуальные сетевые интерфейсы существуют:"
sudo $VBOXMANAGE list hostonlyifs
_echo -n "Хотите мы приступим к созданию сетевого интерфейса для VirtualBox [y/N]?"
read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано."
else
    _echo "Запускаем процесс создания сетевого интерфейса VirtualBox"
    sudo $VBOXMANAGE hostonlyif create
fi

_echo -n "Хотите мы добавим и настроим интерфейс VirtualBox в /etc/network/interfaces [y/N]?"
read s
if [ "$s" != "y" ]; then
    _echo "Хорошо, ничего не сделано."
else
    _echo "Добавление сетевого интерфейса VirtualBox в /etc/network/interfaces"
    sudo cp /etc/network/interfaces /etc/network/interfaces.vboxinstaller.bak
    echo            | sudo tee --append /etc/network/interfaces > /dev/null
    echo "auto vxoxnet0"    | sudo tee --append /etc/network/interfaces > /dev/null
    echo "iface vxoxnet0 inet static"       | sudo tee --append /etc/network/interfaces > /dev/null
    echo "        address         $IP"          | sudo tee --append /etc/network/interfaces > /dev/null
    echo "        netmask         $NETMASK"     | sudo tee --append /etc/network/interfaces > /dev/null
    echo "        network         $NETWORK"     | sudo tee --append /etc/network/interfaces > /dev/null
    echo "        broadcast       $BROADCAST"   | sudo tee --append /etc/network/interfaces > /dev/null
    echo "        pre-up /usr/local/bin/VBoxManage list vms 2>&1 >> /dev/null" | sudo tee --append /etc/network/interfaces > /dev/null
fi

##################################################################################################################

echo "################################################################"
echo "##############            P A I N             ##################"
echo "##############           T V O Y A            ##################"
echo "##############         M A C H I N A          ##################"
echo "##############       O F I C I A L N O        ##################"
echo "##############      P R O H A C H A N A       ##################"
echo "##############           D E L A Y            ##################"
echo "##############          R E B O O T           ##################"
echo "################################################################"
