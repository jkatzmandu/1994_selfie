#!/bin/sh
#
#
# Shell script for guiding users through taking selfies on
# the SGI Indy for the NPL gallery
#

clear

# and clear the TTY!
exec /usr/local/bin/clear_tty.sh &

echo ""
echo "Welcome to the NPL Gallery"
echo ""
echo "In order to demonstrate network packets and packet switching"
echo "we've made the gallery a bit more interactive. On this system"
echo "you can take a selfie! On the CRT next to us, you can then see"
echo "that selfie be e-mailed to you as a series of packets sent across"
echo "the internet. Note that it's possible your #SelfieLikeIts1994 will"
echo "arrive in your SPAM mailbox."
echo ""
echo "Get ready to #SelfieLikeIts1994"
echo ""
echo "In order to send you your selfie, we need your e-mail address."
echo -n "Enter e-mail: "
read ADDRESS
echo ""
echo "The capture program will launch. This will cause a new window to"
echo "appear which will include the camera program looking at you."
echo ""
echo "When you like how you look, click the 'Record' button"
echo "Then, press <CTRL+Q> to exit."
echo ""
echo "Press <ENTER> to launch the capture program, now."

read foo

# Launch the capture program in as close to a kiosk mode as we can...
/usr/sbin/capture -still -fixedMode -fixedFile /tmp/new_photo.rgb -nofork

# Convert from SGI's RGB format to a proper JPEG
echo ""
echo "We're now converting the photo to a proper JPG file. Sometimes"
echo "the software complains of errors, but your selfie is still in good"
echo "hands."
echo ""
/usr/sbin/imgcopy -fjfif /tmp/new_photo.rgb /tmp/indycam.jpg

echo "We're now ready to send you your selfie. Get ready to look"
echo "at the CRT next to us as soon as you press <ENTER> to get your selfie!"

/usr/tgcware/sbin/tcpdump -A -c 22 port 25 > /dev/ttyd1 2>/dev/null &

read foo

# In a perfect world we could do something like:
uuencode /tmp/indycam.jpg TNMOC_Selfie.jpg | Mail -s "Your TNMOC Selfie" ${ADDRESS}

# we need to clean up tmp files to prevent someone from
# stealing the last person's selfie
rm /tmp/indycam.jpg /tmp/new_photo.rgb

echo ""
echo "That's all there is to it! Your selfie is divvied up into packets and sent"
echo "across the internet. Unfortunately, because we're using some older technology"
echo "it's quite likely your selfie is in your SPAM folder, so if you cannot find"
echo "your photo, check there!"

echo "Now that your #SelfieLikeIts1994 is in your inbox, post to your favourite"
echo "social media like Prodigy, AOL, Minitel, or CompuServe! Oh, wait..."

echo ""

echo "Press <ENTER> to start over."

read foo

exec $0
