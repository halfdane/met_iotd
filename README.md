Need more art in your life?
===========================

This small script downloads the image of the day from the Metropolitan Museum and stores it in the directory `~/metIotd`.
Use cron to execute it regularly and setup your screensaver or your backgroundimage to display it to have a daily changing infusion of art.

The filename is comprised by the object's name followed by the artist's (in brackets).

Use with xscreensaver
=====================
- `sudo apt-get install xscreensaver xscreensaver-gl`
- `xscreensaver-demo` and if asked, activate the demon
- Choose "Only One screensaver" from the dropdown
- Select "GLSlideshow" and set the timings as you like
- Change to "Advanced" tab
- Check "Choose Random Image" and select the folder `metIotd` in your home directory () only exists after the script has been run 
- That's it: you can close the window.

If you see errors about fonts being unable to load, edit `~/.xscreensaver` and change `captureStderr:  True` to `captureStderr:  False`

Set up Cron
===========
 
    crontab -e
    @reboot REPLACE_WITH_DIRECTORY/met_iotd/iotd.rb
    @hourly REPLACE_WITH_DIRECTORY/met_iotd/iotd.rb
