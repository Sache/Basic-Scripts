import socket
import random
import _thread
import time
import string

####################################### CONFIGURE HERE ##################################

# Where to host? 
host = '127.0.0.1'

# Which port number?
port =  5000

# Runner
busy = False

####################################### JUST ONCE #####################################

try:
	print("Starting media server")
	serversocket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	serversocket.bind((host, port))
	print("Server up and listenting")
except: 
	print("An error occured while starting server")

####################################### MAIN LOOP ###########################

def AcceptConnection():
        while True:
                message, address = serversocket.recvfrom(1024)
                print("Sent Data:{}".format(message))
                print("Client IP:{}".format(address))
        return None

def ReplyToClient():
        serversocket.sendto(str.encode("Put Reply HERE"), address)



try:

#    _thread.start_new_thread(acceptConnection, ())
        AcceptConnection()

except:
    print("Something went worng.")

