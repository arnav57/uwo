# The Application Layer

Network apps include the web, texts, emails, youtube, etc. Here we will learn about the layer that they operate on 

Network apps are essentially programs that run on different end systems, and communicate over a network. Developers of these apps dont actually need to write software for network-core devices (such as routers). Network-core devices do not run applications, instead they talk to end systems that actually do

## Network Architectures

This introduces the \kw{client-server} paradigm, which describes the above:

Server:

- The \kw{Server} is an always-on host
- It features a permanent IP adress
- and is often in data-centers for faster scaling

Clients:

- Are end systems, user devices
- They can communicate directly with the server only, clients do not talk to other clients
- they might have dynamic IP adresses
- Examples: HTTP, IMAP, FTP

There is also an alternative, the \kw{peer-to-peer} paradigm, where:

- This is no always-on server
- end systems communicate directly with each other
- peers request service from other peers, and return the service to other peers as well
	- This means that this is *self-scalable*, new peers bring new servicie capacity as well as new service demands
- Peers are intermittently connected and change IP adresses with complex management systems
- Example: P2P File Sharing (torrents)

## Communication of Processes

a \kw{process} is a program running within a host. Within the host two processes can communicate through the OS, but processes residing on different hosts must communicate by exchanging messages.

We define the term \kw{client-process} as the process that initiates communication, and the term \kw{server-process} as the process that waits to be contacted. Applications with P2P architectures have both client and server processes.

Processes communicate by sending messages to and from a \kw{socket}, which can be thought of as a *door*. A sending process will:

1. Shove the message out of the door
2. Rely on the transport infrastructure outside of the door to deliver the message to the destination door on the other side

Furthermore, we need to address these processes in other to recieve messages properly. Thus each process must have an *identifier*

This identifier is called the IP address, and it belongs to the host device, that can have multiple processes running at the same time. Furthermore, there are also port numbers such as 80 or 25, that are used as part of the IP address.

## Application Layer Protocols

Now that we know how processes should communicate, what sorts of things should be defined in a protocol used at the application layer?

1. Types of Messages Exchanged
	- A request, response, etc
2. Message Syntax
	- What is included in the message, and how fields are delineated
3. Message Semantics
	- What do each of the fields in the message signify?
4. Rules for when/how processes can send or respond to messages

Some examples of open protocols are HTTP and SMTP, an example of a closed (proprietary) protocol is skype

So what transport services does an app need to actually work?

1. Data Integrity
	- Some appds like file transfer apps require completely reliable data transfer, others can tolerate some loss
2. Timing
	- Some apps (ex. games) require low delay to be effective
3. Throughput
	- Some apps require minimum amount of throughput to be effective
	- Other apps, called *elastic* make use of whatever throughput they can get
4. Security

## Transport Layer Protocols

The application layer heavily depends on the services of the layer below it. The transport layer features TCP and UDP as the main protocols.

TCP provides reliable transport, flow and congestion control, and is connection oriented, however it does not provide timing, a minimum throughput or any security. UDP provides unreliable data transfer, and none of the other benefits of TCP.