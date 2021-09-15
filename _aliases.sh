#My aliases
nexfsi() {
	if [ "$1" = "--loados" ]; then
		(cd /home/nexpos/mynexpos/workdir && ./_loados.sh)
	elif [ "$1" = "--loadutils" ]; then
		(cd /home/nexpos/mynexpos/workdir && ./_loadutils.sh)
	else
		(cd /home/nexpos/mynexpos/nexfs-interface && ./xfs-interface)
	fi
}

export -f nexfsi

nexsm() {
	bgPID=0
	if [ "$1" = "--debug" ]; then
		while true; do
			if [ -f /home/nexpos/mynexpos/nexsm/mem ]; then
				mv /home/nexpos/mynexpos/nexsm/mem .
				sleep 1.5
			fi
			sleep 0.1
		done &

		bgPID=$!
	fi

	(cd /home/nexpos/mynexpos/nexsm && ./xsm "$@")

	if [ "$1" = "--debug" ]; then
		kill $bgPID
		wait $bgPID 2>/dev/null
	fi
}

nespl() {
	ABS_PATH=$(readlink -f $1)
	(cd /home/nexpos/mynexpos/nespl && ./spl $ABS_PATH)
}
export -f nespl

nexfsif() {
	ABS_PATH=$(readlink -f "${@: -1}")
	FILENAME=$(basename "${@: -1}")
	IS_LOADING_EXEC=0
	XFS_COMMAND=""

	if [ "$1" = "load" ] && ([ "$2" = "--exec" ] || [ "$2" = "--data" ]); then
		IS_LOADING_EXEC=1
		XFS_COMMAND+="rm $FILENAME\n"
	fi

	XFS_COMMAND+="${@:1:(($# - 1))} $ABS_PATH"

	if [ "$IS_LOADING_EXEC" -eq 1 ]; then
		XFS_COMMAND+="\ndump --inodeusertable"
	fi

	XFS_COMMAND+="\nexit"

	echo -e "$XFS_COMMAND" | nexfsi

	if [ "$IS_LOADING_EXEC" -eq 1 ]; then
		ENTRY_LINE=$(grep -n $FILENAME /home/nexpos/mynexpos/nexfs-interface/inodeusertable.txt | cut -f1 -d:)
		echo Loaded to disk blocks
		echo $(head -$((ENTRY_LINE + 10)) /home/nexpos/mynexpos/nexfs-interface/inodeusertable.txt | tail +$((ENTRY_LINE + 7)))
	fi

}
export -f nexfsif

expl() {
	ABS_PATH=$(readlink -f $1)
	(cd /home/nexpos/mynexpos/expl && ./expl $ABS_PATH)
}
export -f expl
