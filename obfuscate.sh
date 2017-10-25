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
#
# Для получение значиний скрипт использует:
#
# dmidecode -t0, -t1, t2, -t3, -t4 и -t11 для сбора информации, необходимой для  работы скрипта
#
#
# Измените настройки VirtualBox перед использованием
#
# !!! Перед использованием скрипта VirtualBox необходимо закрыть (завершить) работу программы !!!
#
# Создать свой собственный образ SLIC (таблица описаний лицензий программного обеспечения)
# sudo dd if=/sys/firmware/acpi/tables/SLIC of=SLIC.bin
# mv SLIC.bin /home/<user>/VirtualBox\ VMs/<vm>/SLIC.bin
# sudo chown <vbox users>.<vbox user> /home/<user>/VirtualBox\ VMs/<vm>/SLIC.bin
#
# Создать свой собственный DSDT (Different System Description Table) - Таблица, получаемая из BIOS. Она хранит в себе полный перечень всех устройств вашего компьютера.
# dd if=/sys/firmware/acpi/tables/DSDT of=ACPI-DSDT.bin
# Если заменяющие таблицы ACPI из Linux слишком велики (как это было в моем случае) или по какой-либо другой причине не работают,
# загрузите "Read & Write Everything" из http://rweverything.com/и используйте его для сброса полных двоичных таблиц по умолчанию под вашей гостево системоой Windows.
# Скопируйте файл на вашу оосновную систему и отредактируйте его с помощью 16-го редактора или путем декомпиляции используйте: iasl -d AcpiTbls.bin, затем редактируйте
# результирующий скрипт .dsl а затем перекомпилировать с помощью; iasl -tc AcpiTbls.dsl. задайте результирующую бинарную таблицу .aml как в вашей таблице ACPI
# используя VBoxManage setextradata <machine> "VBoxInternal/Devices/acpi/0/Config/CustomTable" "/yourpath/DSDT.aml". 
# Обязательно измените имена всех поставщиков из VBox/Virtualbox/innotek на что-то другое.
#
# Используйте "VBoxManage list vms" для просмотра названия виртуальных машин
#
# Использование: "obfuscate.sh"

echo "Этот скрипт патчит существующую виртуальную машину в VirtualBox. Он обфусцирует (путает) перемнные (апаратные  строки)"
echo "[ВАЖНО] Перед выполнением этого скрипта убедитесь, что приложение VirtualBox закрыто!"

VMLIST="$(VBoxManage list vms|cut -d' ' -f1)"
echo "Установленные виртуальные машины:"

count=0
for i in $VMLIST; do
    count=`expr $count + 1`
    echo [$count] $i
done
echo -n "Какую из них вы хотите исправить (пропатчить) (1-$count): "
read VMNUM

VMNAME=$(echo $VMLIST | cut -d" " -f$VMNUM | cut -d\" -f2)

echo -n "Хотите ли вы запустить процесс исправления (патча) виртуальной машины: \"$VMNAME\" (y/N)? "
read s
if [ "$s" != "y" ]; then
        echo "Хорошо, ничего не сделано.";
    exit 1
fi

echo "Начниаем исправление (патчим) ВМ, подождите..."

VBOXDIR="/home/user/sources"

SLIC="$VBOXDIR/vboxdata/SLIC.bin"
DSDT="$VBOXDIR/vboxdata/ACPI-DSDT.bin"
SSDT="$VBOXDIR/vboxdata/ACPI-SSDT1.bin"
SPLASH="$VBOXDIR/vboxdata/splash.xcf"
VIDEO="$VBOXDIR/vboxdata/videorom.bin"
PCBIOS="$VBOXDIR/vboxdata/pcbios.bin"
PXE="$VBOXDIR/vboxdata/pxerom.bin"
ACPIDSDT="$VBOXDIR/vboxdata/ACPI-DSDT-new.bin"
ACPISSDT="$VBOXDIR/vboxdata/ACPI-SSDT1-new.bin"

VBOXMAN="/usr/local/bin/VBoxManage"

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/ahci/0/Config/Port0/SerialNumber"     "K30GT7B25GKD"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/ahci/0/Config/Port0/FirmwareRevision" "0000001A"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/ahci/0/Config/Port0/ModelNumber"      "FUJITSU MHW2160BJ G2"

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/ahci/0/Config/Port1/ATAPIVendorId"  "Optiarc"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/ahci/0/Config/Port1/ATAPIProductId" "DVD RW AD-7710H"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/ahci/0/Config/Port1/ATAPIRevision"  "1.S0"

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSVendor"        "HP"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSVersion"       "1.17"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSReleaseDate"   "03/31/2006"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSReleaseMajor"  117
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSReleaseMinor"  22
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSFirmwareMajor" 2
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSFirmwareMinor" 3

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemVendor"      "HP"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemProduct"     "ProLiant DL140 G2"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemVersion"     "419758-001"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemSerial"      "MX262900Z4"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemSKU"         "<EMPTY>"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemFamily"      "Xeon"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemUuid"        "747EED80-64DE-1000-BEF2-D628C931D455"

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardVendor"       "Wistron Corporation"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardProduct"      "M75ILA"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardVersion"      "Revision A1"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardSerial"       "L3X4719"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardAssetTag"     "<EMPTY> "
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardLocInChass"   "Not Present"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardType"         ""

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiChassisVendor"     "HP"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiChassisVersion"    "N/A"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiChassisType"       "10"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiChassisSerial"     "MX262900Z4"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiChassisAssetTag"  " "

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiProcManufacturer"  "Intel"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiProcVersion"       "Intel(R) Xeon(TM) CPU"

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiOEMVBoxVer"        "string:0x00001234"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiOEMVBoxRev"        " "

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/acpi/0/Config/CustomTable" $SLIC
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/acpi/0/Config/AcpiOemId" "ASUS"

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/acpi/0/Config/DsdtFilePath" $ACPIDSDT
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/acpi/0/Config/SsdtFilePath" $ACPISSDT
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/vga/0/Config/BiosRom" $VIDEO
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/BiosRom" $PCBIOS
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/LanBootRom" $PXE

$VBOXMAN modifyvm "$VMNAME" --macaddress1 6CF1481A9E03          # Изменение MAC-адреса виртуальной сетевой карты
#$VBOXMAN modifyvm "$VMNAME" --bioslogoimagepath $SPLASH        # Эта хуета больше не работает по факту, все притензии к Oracle (создатели VirtualBox)
$VBOXMAN modifyvm "$VMNAME" --paravirtprovider legacy           # Избегаем ообнаружения idetection с помощью cpuid проверки

$VBOXMAN getextradata "$VMNAME" enumerate
