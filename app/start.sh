#!/bin/bash


# By default docker gives us 64MB of shared memory size but to display heavy
# pages we need more.
umount /dev/shm && mount -t tmpfs shm /dev/shm
rm /tmp/.X0-lock &>/dev/null || true

# set hostname based on balena uuid
HNAME="rpi-${BALENA_DEVICE_UUID:0:7}"
echo $HNAME > /etc/hostname
hostname $HNAME

# changing xwrapper config to run for any user
sed -i -e 's/console/anybody/g' /etc/X11/Xwrapper.config

# adding user to run chromium since it will not run as root
useradd chromium -m -s /bin/bash -G root
usermod -a -G root,tty chromium

# adding script to start chromium
echo "#!/bin/bash" > /home/chromium/xstart.sh
echo "chromium-browser --start-fullscreen --window-size=1920,1080  --no-first-run --disable-infobars --kiosk $URL_LAUNCHER_URL --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage " >> /home/chromium/xstart.sh

chmod 770 /home/chromium/xstart.sh
chown chromium:chromium /home/chromium/xstart.sh


#get the display context and xauthority
export DISPLAY=:0
export XAUTHORITY=/home/chromium/.Xauthority

# Start cursor at the top-left corner, as opposed to the default of dead-center
# (so it doesn't accidentally trigger hover styles on elements on the page)
xdotool mousemove 0 0

# Set some useful X preferences
xset s off # don't activate screensaver
xset -dpms # disable DPMS (Energy Star) features.
xset s noblank # don't blank the video device


# Remove notes of previous sessions, if any
find /home/chromium/.config/chromium/ -name "Last *" | xargs rm
# Make sure Chromium profile is marked clean, even if it crashed
if [ -f /home/chromium/.config/chromium/Default/Preferences ]; then
    cat /home/chromium/.config/chromium/Default/Preferences \
        | jq '.profile.exit_type = "SessionEnded" | .profile.exited_cleanly = true' \
        > /home/chromium/.config/chromium/Default/Preferences-clean
    mv /home/chromium/.config/chromium/Default/Preferences{-clean,}
fi

##Activate the cronjob
chmod 770 /usr/src/app/crontab.example

crontab < /usr/src/app/crontab.example
# starting chromium as chrome user
su -c 'startx /home/chromium/xstart.sh' chromium


# Default to UTC if no TIMEZONE env variable is set
echo "Setting time zone to ${TIMEZONE=UTC}"
# This only works on Debian-based images
echo "${TIMEZONE}" > /etc/timezone
dpkg-reconfigure tzdata



## Hide Chromium while it's starting/loading the page
#wid=`xdotool search --sync --onlyvisible --class chromium`
#xdotool windowunmap $wid
#sleep 15 # give the web page time to load
#xdotool windowmap $wid

##List available modes
#/opt/vc/bin/tvservice -m CEA
#/opt/vc/bin/tvservice -m DMT
tvservice -e "CEA 32"


