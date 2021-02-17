#!/bin/bash
# @By HalCroves

# Couleurs
    NORMAL="\033[0;39m"
    ROUGE="\033[1;31m"
    VERT="\033[1;32m"
    ORANGE="\033[1;33m"
	
# Messages customs
    MSG_180="Ein Sturm nähert sich, in 3 Minuten wird die Stadt zerstört !"
    MSG_60="Ein Sturm ist vor den Toren der Stadt, lauf weg arme Narren !"
    MSG_30="Mein Gott !! In 30 Sekunden sind Sie alle tot, wenn Sie nicht weglaufen !"
	
# Path
    FIVEM_PATH=/home/FiveM

# Screen
    SCREEN="fxserver"

cd $FIVEM_PATH	
running(){
    if ! screen -list | grep -q "$SCREEN"
    then
        return 1
    else
        return 0
    fi
}	

case "$1" in
    # -----------------[ Start ]----------------- #
    start)
	if ( running )
	then
	    echo -e "$ROUGE Der Server [$SCREEN] ist bereits gestartet !$NORMAL"
	else
		echo -e "$ROUGE MySQL wird neu gestartet !$NORMAL"
		sudo service mysql restart
		sleep 10
		echo -e "$ORANGE Der Server [$SCREEN] wird gestartet. $NORMAL"
		screen -dm -S $SCREEN
		sleep 2
		screen -x $SCREEN -X stuff "cd "$FIVEM_PATH"/server-data && bash "$FIVEM_PATH"/server/run.sh +exec server.cfg 
		"
		echo -e "$ORANGE Starte den Sessionmanager neu $NORMAL"
		sleep 20
		screen -x $SCREEN -X stuff "restart sessionmanager
		"
		echo -e "$VERT Session Ok ! $NORMAL"
		sleep 5
		echo -e "$VERT Server Ok ! $NORMAL"
	fi
    ;;
    # -----------------[ Stop ]------------------ #
    stop)
	if ( running )
	then
		echo -e "$VERT Der Server wird in 10s gestoppt. $NORMAL"
		screen -S $SCREEN -p 0 -X stuff "`printf "say $MSG_30\r"`"; sleep 30
		screen -S $SCREEN -X quit
		echo -e "$ROUGE Der Server [$SCREEN] wurde gestoppt. $NORMAL"
		sleep 5
		echo -e "$VERT Server [$SCREEN] ist ausgeschaltet. $NORMAL"
		rm -R $FIVEM_PATH/server-data/cache/
		echo -e "$VERT Cache wurde bereinigt. $NORMAL"

	else
	    echo -e "Der Server [$SCREEN] ist nicht gestartet."
	fi
    ;;
    # ----------------[ Restart ]---------------- #
	restart)
	if ( running )
	then
	    echo -e "$ROUGE Der Server [$SCREEN] läuft bereits!  $NORMAL"
	else
	    echo -e "$VERT Der Server [$SCREEN] ist ausgeschaltet. $NORMAL"
	fi
	    echo -e "$ROUGE Der Server wird neu gestartet ... $NORMAL"
		screen -S $SCREEN -p 0 -X stuff "`printf "say $MSG_180\r"`"; sleep 180
		screen -S $SCREEN -p 0 -X stuff "`printf "say $MSG_60\r"`"; sleep 60
		screen -S $SCREEN -p 0 -X stuff "`printf "say $MSG_30\r"`"; sleep 30
		screen -S $SCREEN -X quit
		echo -e "$VERT Der Server ist aus. $NORMAL"
		rm -R $FIVEM_PATH/server-data/cache/
		echo -e "$VERT Cache wurde bereinigt. $NORMAL"
		sleep 2
		echo -e "$ORANGE Neustart läuft ... $NORMAL"
		echo -e "$ROUGE MySQL wird neu gestartet !$NORMAL"
		sudo service mysql restart
		sleep 10
		echo -e "$ORANGE Le serveur [$SCREEN] va démarrer.$NORMAL"
		screen -dm -S $SCREEN
		sleep 2
		screen -x $SCREEN -X stuff "cd "$FIVEM_PATH"/server-data && bash "$FIVEM_PATH"/server/run.sh +exec server.cfg 
		"
		echo -e "$ORANGE Starte den Sessionmanager neu $NORMAL"
		sleep 20
		screen -x $SCREEN -X stuff "restart sessionmanager
		"
		echo -e "$VERT Serveur [$SCREEN] Start! $NORMAL"
	;;	
    # -----------------[ Status ]---------------- #
	status)
	if ( running )
	then
	    echo -e "$VERT Der Server [$SCREEN] läuft gerade. $NORMAL"
	else
	    echo -e "$ROUGE Der Server [$SCREEN] läuft zur zeit nicht. $NORMAL"
	fi
	;;
    # -----------------[ Screen ]---------------- #
    screen)
        echo -e "$VERT Starte Screen Session $NORMAL"
        screen -R $SCREEN
    ;;
	*)
    echo -e "$ORANGE Benutzung:$NORMAL ./manage.sh {start|stop|status|screen|restart}"
    exit 1
    ;;
esac

exit 0
