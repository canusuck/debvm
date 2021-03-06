# Инструкция по установке

git clone https://github.com/canusuck/debvm.git && cd debvm && chmod +x install.sh && ./install.sh

# 1. Изменение параметров на свои

Откройте в папке vbox файл patch-vbox.sh и измените в строке debvmDIR=/home/user/debvm/vbox имя пользователя "user" на свое, которое используется в системе.

Так же вы можете изменить название переменных на свои, если будете их изменять, то в скрипте, ищите так же название переменных в первоначальном виде и изменяйте его на ваше, длинну переменных не изменять! 

- VirtualBox=XirtualXox
- virtualbox=xirtualxox
- VIRTUALBOX=XIRTUALXOX
- virtualBox=xirtualXox
- vbox=vxox
- Oracle=Xracle
- oracle=xracle
- innotek=xnnotek
- InnoTek=XnnoTek
- INNOTEK=XNNOTEK
- PCI80EE=80EF
- PCI80ee=80ef
- Vbox=Vxox
- VBox=VXox
- VBOX=VXOX

Далее следуйте подсказкам в скрипте

# 2. Настройка VM (после перезагрузки)

Создаем виртуальную Win7 (64bit)

Примечание. Не устанавливайте дополнительные компоненты или дополнения!!!

# Вкладка System

Motherboard:

- RAM: 4 GB
- Chipset - PIIX3                                     (или необходимо адаптировать сценарий позднее)
- Poinitng Device: PS/2                               (в противном случае мы не можем отключить USB позднее)
- Extended Features ставим галку на Enable I/O        (не уверен что нужно)
- Hardware Clock in UTC                               (не уверен, что нужно)

Processor:
- CPU: 2 cores                                        (recomended 4)

Acceleration:
- Paravirtualization interface: Legacy                (это позволяет избежать обнаружения через CPUID)
- Включить - VT-x/AMD-V                               (needed for x64)
- Включить - Nested Paging                            (Позволяет управлять памятью хоста, что позволяет усилить производительность , т.к. не требуется программное управление памятью).

# Display
- GPU: 64 MB RAM - Убрать галочки с 2D, 3D акселерации
- Extended Features - Выключить

# Storage
- Controller - Use host I/O cache                     (если галочка стоит будут, использованы функции кешироования операций ввода/вывода данного хоста).
- Тип диска - Обычный VDI
- Информация самого диска - Динамический

# Audio
Pulse audio (рекомендую использовать на виртуальной машине VAC - Virtual Audio Cable) (изменяем в ней битрейт и количество динамиков) - это нужно для подделки AudioFingerprint

# Network
- Тип подключения: Виртуальный адаптер хоста (vboxnet0) 
- Дополнительно - Тип адаптера: PCnet-Fast III

# COM-ports
- Выключить - последовательные порты

# USB
- Выключить - USB

- Остальные можно оставить по умолчанию...

# Важно

-Не забываем прикрутить образ нашего диска
-Ни в коем случае не запускаем VM

# 3. Патчим нашу VM скриптом
- В скрипте obfuscater.sh измените строку VBOXDIR="/home/user/debvm", а точнее имя пользователя "user" на свое и конечную папку скрипта, в мооем случае он скаичвается в папку debvm.
- Далее запускаем obfuscater.sh с помощью ./obfuscater.sh     (Перед использованием скрипта VirtualBox необходимо закрыть (завершить) работу программы).

# 4. Запуск VirtualBox 
Запускаем VirtualBox и нашу виртуальную машину Win7, которую мы ранее создали и устанавливаем нашу ОС.

# 5. Проверяем нашу машину на детект

Для этого вы можете использовать следующие програмы

- pafish
- vmde
- al-khaser
- hu-cpuid-check
- hu-vmdetect
- procexp
- DWS_Lite

# The end

Конец, на этом наша установка подошла к концу. 
