#####################################################################################################
#### AISE 4430 - Lab 1 Code
#####################################################################################################
#### Author: 
#### 	Arnav Goyal
####
#### Description:
####	This is a script that will unironically actually send an email 
####	Using google/gmail mail server, this is done with socket programming
####	and sending actual commands over TLS. This script will not work unless you provide
####	The proper secrets file with emails and a google app password
####	The overall sequence of events is below
####			1. Create Socket and connect to gmail server
####			2. Send HELO command
####			3. Send STARTTLS command to upgrade to TLS level comms
####			4. Also wrap our socket in ssl context so it is secure
####			5. Send EHLO command so secure comms can be renegotiated
####			6. Send AUTH LOGIN command followed by the b64 fields from secrets file
####			7. Send MAIL FROM command to show who sent the email
####			8. Send RCPT TO command to send the email to myself
####			9. Send DATA coommand followed by the message contents set from the lab's skeleton code
####		   10. Send QUIT command to end the TLS connections and close the socket 
#### References:
####	1. Course Lab PDF & Skeleton Code
####    2. https://github.com/uphunyal/simple_smtp/blob/master/smtp.py 
####	3. https://docs.python.org/3/howto/sockets.html
####################################################################################################

########################### IMPORTS ###########################
from socket import *
import ssl
import base64

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


########################### SOCKET SETUP ###########################
# Choose a mail server (e.g. Google mail server) and call it mailserver
# here i will choose the gmail server
mailserver = "smtp.gmail.com"
mailserverport = 587 # here we will be using TLS, the SSL port is 465

# Create socket called clientSocket and establish a TCP connection with mailserver
# here I create a socket object and actually connect the socket to the google mail server
clientSocket = socket(AF_INET, SOCK_STREAM)
clientSocket.connect((mailserver, mailserverport))

## The below loc is copy-pasted throughout, i am not making it a function because i have no clue what
## these return codes mean and i am not googling all of them.
## It basically decodes the message sent back from the gmail server and prints it
recv = clientSocket.recv(1024).decode()
print(recv)

if recv[:3] != '220':
	print('220 reply not received from server.')



########################### HELO CMD ###########################
##### Send HELO command and print server response.
heloCommand = 'HELO Alice\r\n'
clientSocket.send(heloCommand.encode())

## print reply from google server
recv1 = clientSocket.recv(1024).decode()
print(recv1)

if recv1[:3] != '250':
	print('250 reply not received from server.')




########################### STARTTLS CMD ###########################
# need to send STARTTLS for authentication over TLS
emailtls = "STARTTLS\r\n"
clientSocket.send(emailtls.encode())

recv = clientSocket.recv(1024).decode()
print(recv)

# now that we told gmail to start TLS we must wrap our socket with TLS/SSL
context = ssl.create_default_context()
clientSocket = context.wrap_socket(clientSocket, server_hostname=mailserver)


########################### EHLO CMD ###########################
# gmail needs to reneg the connection after upgrading to TLS
# so we need to send EHLO this time

heloCommand = 'EHLO Alice\r\n'
clientSocket.send(heloCommand.encode())

recv1 = clientSocket.recv(1024).decode()
print(recv1)

if recv1[:3] != '250':
	print('250 reply not received from server.')

########################### AUTH LOGIN CMD ###########################
# send AUTH LOGIN command with hidden fields such as email and password
# Note that i am not providing these secrets with this lab code
# Also Note that the secrets need to be encoded in b64

emailauth = "AUTH LOGIN\r\n"
clientSocket.send(emailauth.encode())

recv = clientSocket.recv(1024).decode()
print(recv)

# if we dont encode in b64 everything breaks lol
uname = base64.b64encode(LOCAL_EMAIL_ADDR.encode()) + b'\r\n'
pw    = base64.b64encode(LOCAL_EMAIL_PW.encode()) + b'\r\n'

clientSocket.send(uname)

recv = clientSocket.recv(1024).decode()
print(recv)

clientSocket.send(pw)

recv = clientSocket.recv(1024).decode()
print(recv)


########################### MAIL FROM CMD ###########################
# Send MAIL FROM command and print server response.
 
emailfrom = f"MAIL FROM:<{LOCAL_EMAIL_ADDR}>\r\n"
clientSocket.send(emailfrom.encode())

recv = clientSocket.recv(1024).decode()
print(recv)

########################### RCPT TO CMD ###########################
# Send RCPT TO command and print server response.

emailto = f"RCPT TO:<{LOCAL_EMAIL_ADDR}>\r\n"
clientSocket.send(emailto.encode())

recv = clientSocket.recv(1024).decode()
print(recv)

########################### DATA CMD ###########################
# Send DATA command and print server response.

emaildata = "DATA\r\n"
clientSocket.send(emaildata.encode())

recv = clientSocket.recv(1024).decode()
print(recv)

if recv[:3] != '354':
    print("Server did not accept DATA command.")


# Send message data.
clientSocket.send(msg.encode())

# Message ends with a single period.
clientSocket.send(endmsg.encode())

recv = clientSocket.recv(1024).decode()
print(recv)

########################### QUIT CMD ###########################
# Send QUIT command and get server response.
# After this we close the socket

emailquit = "QUIT\r\n"
clientSocket.send(emailquit.encode())

recv = clientSocket.recv(1024).decode()
print(recv)

clientSocket.close()
