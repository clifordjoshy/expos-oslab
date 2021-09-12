#My aliases
xfsi() {
	if [ "$1" = "--loados" ]; then
		(cd /home/expos/myexpos/workdir/common && ./_loados.sh)
	elif [ "$1" = "--loadutils" ]; then
		(cd /home/expos/myexpos/workdir/common && ./_loadutils.sh)
	else
		(cd /home/expos/myexpos/xfs-interface && ./xfs-interface)
	fi
}

export -f xfsi

xsm() {
	bgPID=0
	if [ "$1" = "--debug" ]; then
		while true; do
			if [ -f /home/expos/myexpos/xsm/mem ]; then
				mv /home/expos/myexpos/xsm/mem .
				sleep 1.5
			fi
			sleep 0.1
		done &

		bgPID=$!
	fi

	(cd /home/expos/myexpos/xsm && ./xsm "$@")

	if [ "$1" = "--debug" ]; then
		kill $bgPID
		wait $bgPID 2>/dev/null
	fi
}

spl() {
	ABS_PATH=$(readlink -f $1)
	(cd /home/expos/myexpos/spl && ./spl $ABS_PATH)
}
export -f spl

xfsif() {
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

	echo -e "$XFS_COMMAND" | xfsi

	if [ "$IS_LOADING_EXEC" -eq 1 ]; then
		ENTRY_LINE=$(grep -n $FILENAME /home/expos/myexpos/xfs-interface/inodeusertable.txt | cut -f1 -d:)
		echo Loaded to disk blocks
		echo $(head -$((ENTRY_LINE + 10)) /home/expos/myexpos/xfs-interface/inodeusertable.txt | tail +$((ENTRY_LINE + 7)))
	fi

}
export -f xfsif

expl() {
	ABS_PATH=$(readlink -f $1)
	(cd /home/expos/myexpos/expl && ./expl $ABS_PATH)
}
export -f expl
