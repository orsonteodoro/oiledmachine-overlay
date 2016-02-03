#!/bin/bash
export WINEPREFIX="${HOME}/.wine32_avrstudio"
export WINEARCH=win32
wineboot -i
mkdir -p "${HOME}/.wine32_avrstudio"
winetricks -q ie6 || exit
winetricks -q mdac28 || exit
winetricks -q gdiplus || exit
winetricks -q vcrun2005 || exit
winetricks -q msxml3 || exit

#echo 'export WINEDLLOVERRIDES="msxml3,ole32,oleaut32,rpcrt4=n"

#preform unattended install instead
(while true
 do
	ps -aux | grep AvrStudio4Setup.exe | grep -v grep
	if [[ "$?" == "0" ]]; then
		echo "Probing AVRJungoUSB.exe"
		while true
		do
			ps -aux | grep AVRJungoUSB.exe | grep -v grep
			if [[ "$?" == "0" ]]; then
				echo "Found and killing AVRJungoUSB.exe"
				kill -9 $(ps -aux | grep AVRJungoUSB.exe | grep -v grep | awk '{print $2}') &>/dev/null
				break
			fi
		done
		break
	fi
 done) &

#main exe
wine "/usr/portage/distfiles/AvrStudio4Setup.exe" /s /sms /f1"z:\usr\share\avr-studio\setup.iss" /f2"c:\install.log"

#jungo usb driver wine "${HOME}/.wine32_avrstudio/dosdevices/c:/Program Files/Atmel/AVR Tools/AVRJungoUSB.exe" /s /sms /f1"z:\usr\share\avr-studio\jungo-setup.iss" /f2"c:\install.log"

cd "${HOME}/.wine32_avrstudio/dosdevices/c:/Program Files/Atmel/AVR Tools/AvrStudio4"
if [[ -f "/usr/bin/wrestool" ]]; then
	wrestool -x -t 14 AVRStudio.exe > icon.ico
fi

echo "[Desktop Entry]" > "${HOME}/.local/share/applications/atmel-avrstudio.desktop"
echo "Version=1.0" >> "${HOME}/.local/share/applications/atmel-avrstudio.desktop"
echo "Type=Application" >> "${HOME}/.local/share/applications/atmel-avrstudio.desktop"
echo "Categories=Development;IDE" >> "${HOME}/.local/share/applications/atmel-avrstudio.desktop"
echo "Name=AVR Studio" >> "${HOME}/.local/share/applications/atmel-avrstudio.desktop"
echo "Exec=${HOME}/bin/avrstudio" >> "${HOME}/.local/share/applications/atmel-avrstudio.desktop"
echo "Icon=${HOME}/.wine32_avrstudio/dosdevices/c:/Program Files/Atmel/AVR Tools/AvrStudio4/icon.ico" >> "${HOME}/.local/share/applications/atmel-avrstudio.desktop"

mkdir -p "${HOME}/bin"
echo "#!/bin/bash" > "${HOME}/bin/avrstudio"
echo "export WINEPREFIX=\"\${HOME}/.wine32_avrstudio\"" >> "${HOME}/bin/avrstudio"
echo "export WINEARCH=win32" >> "${HOME}/bin/avrstudio" >> "${HOME}/bin/avrstudio"
#echo "export WINEDLLOVERRIDES=\"msxml3,ole32,oleaut32,rpcrt4=n\"" >> "${HOME}/bin/avrstudio"
echo "cd \"\${HOME}/.wine32_avrstudio/dosdevices/c:/Program Files/Atmel/AVR Tools/AvrStudio4/\"" >> "${HOME}/bin/avrstudio"
echo "wine AVRStudio.exe" >> "${HOME}/bin/avrstudio"
chmod +x "${HOME}/bin/avrstudio"

grep -r -e 'export PATH="${PATH}:${HOME}/bin"' "${HOME}/.profile" &>/dev/null
if [[ "$?" != "0" ]]; then
	echo 'export PATH="${PATH}:${HOME}/bin"' >> "${HOME}/.profile"
fi

if [[ -f /usr/bin/xdg-desktop-menu ]]; then
	xdg-desktop-menu forceupdate --mode user
fi

if [[ -f /usr/bin/xfdesktop ]]; then
	killall -HUP xfdesktop
	#xfdesktop --reload
fi

echo "You may need to restart to update application panel menu."
echo "Done installing AVR Studio"
