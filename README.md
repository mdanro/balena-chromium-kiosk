# BalenaOS/BalenaCloud RaspberryPi Chromium Kiosk
This is a simple kiosk for loading a web site in Chromium running on a Raspberry PI using BalenaOS/Balena Cloud. 
## Original Source
The project was originally a fork from the [resin-electronjs](https://github.com/balena-io/resin-electronjs) template.
forked from jayatvars/balena-chromium-kiosk

Inspired from https://github.com/futurice/chilipie-kiosk
But several work-arounds adopted to be able to run inside the container

## Updates
Updated from the original fork to use Chromium and the latest Balena Libs. The template will load the necessary packages and initialize [systemd](https://github.com/balena-io-playground/balenalib-systemd-example) which is required for local device input to the app container. The chromium user is created, given appropriate permissions and Chromium is launched. 

Furthermore the cron is configured and dedicated cronjob is setup from container creation to manage cycling through tabs
It relies on a balena variable (space delimited) site links to open chrome in kiosk mode with multiple sites opened.
The default crontab.example is a sugestion of cronjobs including restarting and closing the display

## Hardware
Tested on Raspberry Pi 3b and 3b+. Input from local device touch screen, keyboard and a USB wedge scanner has been tested. Use at your own risk.
## Getting Started
[What is Balena](https://www.balena.io/what-is-balena/)
Several files are most important in this release:
dockerfile.template - hold the details to define the container
app/start.sh - container entry point and execution path
crontab.example - the initial cron file 

run crontab -e to change the running jobs
run crontab -l to see what is going to be run



## Environment Variables
Create an enviroment variable in your Balena app named URL_LAUNCHER_URL and assign it your web accessible URL. The Chromium start page loads by default. Adding multiple space sepparated sites will open several tabs. The application allready cycles between tabs at 1 minute interval (Check cronexaple.tab)



### Disclaimer
No expert claims here. ;) I am sure there are better ways to put this together. But this solution works for us and meets our needs.
