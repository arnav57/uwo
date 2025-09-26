#####################################################################################################
#### AISE 4430 - Lab 1 Code
#####################################################################################################
#### Author: 
#### 	Arnav Goyal
####
#### Description:
####	This is a script that will unironically actually send an email 
####	to an inbox with SMTPLIB in python
#### References:
####	1. https://realpython.com/python-send-email/
####
####################################################################################################


########################### IMPORTS ###########################
import ssl
import smtplib

## SECRETS FILE holding the email and generated app password
from secrets import LOCAL_EMAIL_ADDR, LOCAL_EMAIL_PW

########################### EMAIL CONTENTS ###########################
# This is preset by the lab
msg = "\r\n I love computer networks!"
endmsg = "\r\n.\r\n"

########################### SECRETS ###########################
# validate that secrets are loaded properly in this script
print(f"Using email {LOCAL_EMAIL_ADDR}")
print(f"Using pass {LOCAL_EMAIL_PW}")

########################### SERVER SETUP ###########################
# Choose a mail server (e.g. Google mail server) and call it mailserver
# here i will choose the gmail server
mailserver = "smtp.gmail.com"
mailserverport = 587 # here we will be using TLS, the SSL port is 465

context = ssl.create_default_context()
server = smtplib.SMTP(mailserver, mailserverport)

########################### SEND EMAIL ###########################

# send the ehlo to the server
server.ehlo()

# start the TLS link
server.starttls(context=context)

# send ehlo for reneg of connection
server.ehlo()

# login with creds from secret file
server.login(LOCAL_EMAIL_ADDR, LOCAL_EMAIL_PW)

# send the mail (sender, recipient, message)
server.sendmail(LOCAL_EMAIL_ADDR, LOCAL_EMAIL_ADDR, msg+endmsg)

# close the connection
server.quit()