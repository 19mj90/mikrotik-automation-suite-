/system scheduler
add comment="comiesieczny -backup" interval=1d name=schedule111 on-event="# ==\
    ==============================\
    \n# BACKUP + LOGI NA EMAIL - ROS 7.20 SAFE\
    \n# ================================\
    \n\
    \n:local currentDate [/system clock get date]\
    \n:local currentTime [/system clock get time]\
    \n\
    \n# Wyci\C4\85gni\C4\99cie dnia niezale\C5\BCnie od formatu\
    \n:local currentDay\
    \n\
    \n:if (\$currentDate ~ \"/\") do={\
    \n    :if ([:pick \$currentDate 0 3] ~ \"[0-9]\") do={\
    \n        :set currentDay [:pick \$currentDate 0 2]\
    \n    } else={\
    \n        :set currentDay [:pick \$currentDate 4 6]\
    \n    }\
    \n} else={\
    \n    :set currentDay [:pick \$currentDate 8 10]\
    \n}\
    \n\
    \n# ================================\
    \n# Wykonuj tylko 1 dnia miesi\C4\85ca\
    \n# ================================\
    \n:if (\$currentDay = \"1\") do={\
    \n\
    \n    :local identity [/system identity get name]\
    \n\
    \n    # Tworzenie bezpiecznej daty YYYYMMDD\
    \n    :local y [:pick \$currentDate 0 4]\
    \n    :local m [:pick \$currentDate 5 7]\
    \n    :local d [:pick \$currentDate 8 10]\
    \n\
    \n    # Tworzenie bezpiecznej godziny HHMMSS\
    \n    :local h [:pick \$currentTime 0 2]\
    \n    :local min [:pick \$currentTime 3 5]\
    \n    :local s [:pick \$currentTime 6 8]\
    \n\
    \n    :local safeName (\$identity . \"_\" . \$y . \$m . \$d . \"_\" . \$h \
    . \$min . \$s)\
    \n\
    \n    # ================================\
    \n    # LOGI\
    \n    # ================================\
    \n    /log print file=logs\
    \n\
    \n    # ================================\
    \n    # BACKUP BINARNY\
    \n    # ================================\
    \n    /system backup save encryption=aes-sha256 name=\$safeName\
    \n\
    \n    # ================================\
    \n    # EXPORT RSC\
    \n    # ================================\
    \n    /export file=\$safeName\
    \n\
    \n    /delay 10\
    \n\
    \n    # ================================\
    \n    # EMAIL\
    \n    # ================================\
    \n    /tool e-mail send \\\
    \n        to=\"netadmin@globitel.pl\" \\\
    \n        from=\"powiadomienia@globitel.pl\" \\\
    \n        subject=(\"\$identity - Logi i backup routera\") \\\
    \n        body=(\"Data: \" . \$currentDate . \" Godzina: \" . \$currentTim\
    e . \" - wyslano backup i konfiguracje\") \\\
    \n        file=(\"logs.txt,\" . \$safeName . \".backup,\" . \$safeName . \
    \".rsc\")\
    \n\
    \n    /log warning \"Wyslalem logi i backup na maila\"\
    \n\
    \n    /delay 10\
    \n\
    \n    # ================================\
    \n    # USUWANIE PLIK\C3\93W\
    \n    # ================================\
    \n    :if ([:len [/file find name=\"logs.txt\"]] > 0) do={\
    \n        /file remove logs.txt\
    \n    }\
    \n\
    \n    /file remove [/file find name=(\$safeName . \".backup\")]\
    \n    /file remove [/file find name=(\$safeName . \".rsc\")]\
    \n}\
    \n" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2020-02-24 start-time=00:00:01
