#!/bin/bash
# lazy man password generator
# version 0.1

usage() {
    echo -e "Usage: $(basename "$0") [-l] [-s] [-h]"
    echo -e "\t-l\tless powerful password"
    echo -e "\t-s\tshow passowrd on screen"
    echo -e "\t-h\tprint this help info"
    echo -e ""
    exit 1
}

help() {
    echo -e "Install xsel for Linux"
    echo -e ""
    exit 1
}

copy() {
    sys=$(uname -s)
    if [ "$sys" = Darwin ]; then
        pbcopy $@
    elif [ "$sys" = Linux ]; then
        which xsel &>/dev/null || help
        xsel $@
    fi
}

echo "Lazy man password generator "
echo "Version 0.1"
echo ""

while getopts ":lsh" opt; do
    case "$opt" in
        l)  lesspower="y";;
        s)  show="y";;
        h|*)  usage;;
    esac
done
shift $((OPTIND-1))

echo -n "[1]. your username: "
# you can change username here and uncomment it
# to avoid input username every time
#username=feix
if [ -n "$username" ]; then
	echo $username
else
	read username
fi

echo -n "[2]. Site information key: "
read keyword

echo -n "[3]. your passphrase: "
read -s passphrase
concat="strongpassword"

shapass=$(echo -n ${username}${concat}${keyword}${concat}${passphrase} | sha256sum | awk '{print $1}')

pass=""
for ((i=0; i<${#shapass}; i+=2)); do
	((num=16#${shapass:$i:2}))
	# printable char and not in (\ ` " ')
	if [ "$num" -lt 127 ] && [ "$num" -gt 32 ] && [ "$num" -ne 92 ] && [ "$num" -ne 96 ] && [ "$num" -ne 34 ] && [ "$num" -ne 39 ]; then
		if [ -z "$lesspower" ]; then
			pass=$(printf "\x$(printf %x ${num})")${pass}
		elif [ "$num" -lt 58 -a "$num" -gt 47 ] || [ "$num" -lt 91 -a "$num" -gt 64 ] || [ "$num" -lt 123 -a "$num" -gt 96 ]; then
			pass=$(printf "\x$(printf %x ${num})")${pass}
		fi
	fi
done

if [ "${#pass}" -lt 7 ]; then
	pass=${pass}${pass}
fi
if [ "${#pass}" -gt 14 ]; then
	pass=${pass:(-14):14}
fi
echo -n "$pass" | copy

echo ""
echo -e "\033[1;34mPassword is in you clipboard, just paste it.\nClipboard will be clear 15 seconds later.\033[0m"
if [ -n "$show" ]; then
	echo -e "\033[1;33mPassword: ${pass}\033[0m"
fi

sleep 15 && (echo -n "" | copy) &
