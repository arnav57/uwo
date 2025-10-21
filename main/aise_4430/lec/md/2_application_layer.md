# The Application Layer

## Principles of the Application Layer

The goals for this section are to learn about the \kw{conceptual} and \kw{implementation} aspects of the application layer protocols.


### Network Applications

A lot of the things we use everyday on the internet are \kw{network apps} and this entire model was created to support them!

- Webpages
- Emails
- YouTube
- etc.

So how do we actually create a network app? Well the only things we need to consider are:

1. What are the services provided by the transport layer?
1. What does the API look like for these transport layer services?

With this in mind there are two \kw{architectures} for these network apps, the \kw{client-server}, and the \kw{peer-to-peer (P2P)} model. 

In the Client-Server model, there is an *always-on host* with a constant IP address, and each client operates by contacting and communicating with this server. The clients do not interact with each other, and can have Dynamic IP addresses.

In the P2P architecture there is no server, and the peers (clients) talk to one another. These peers can help each other out by asking for help (sending requests), and helping others (handling requests).

### Processes and Communication

So overall a network app is not going to be a single program, a network app will be multiple programs. More commonly we call these programs a \kw{process}. If these processes communicate within a single host, this is called \kw{inter-process communication (IPC)}. What we care about is communication between different hosts, which occurs by sending some sort of messages back and forth.

Usually the process that initiates communication is called the \kw{client process}, and the process that waits to be contacted is called the \kw{server process}.

A process usually has its own *mailbox*, which we refer to as a \kw{socket}, this socket is how the process sends or recieves its messages. These processes rely on the underlying infrastructure of the transport layer to get things routed properly, and obviously since we are communicating between different hosts, there will be a socket on each side.

So how do we know which socket is the correct one? How can we actually identify a socket? The straightforward answer is exactly what we expect, its some sort of *unique identifier*. This unique identifier is made up of two things:

- The \kw{IP Address} of the host
- The \kw{Port Number} associated with the host process

We need two identifiers because an IP address represents a single device, but there can be many processes running on this device, which is where the port number comes in to narrow down the specific process on this host device.

Some port numbers are reserved for use on a specific service or protocol, for example HTTP servers run on port 80, and mail servers are on port 25.

### Protocols

We know what a \kw{protocol} is at a high level, so defining an application layer protocol we will need to define the following:

- What types of messages are exchanged?
- What is the syntax of these messages?
- What is the meaning of each thing in these messages?
- What do we do after we recieve a message?

So nothing too crazy.

### Transport Layer Services

Earlier we mentioned that creating a network app, means that we need to consider the services available on the layer below, the transport layer. Lets take a look at the types of services available for use here. One basically ubiquitous service is *data transfer*, almost every app needs this in some way. But this is not a one-size fits all solution!

- Some apps require perfect data transfer, stuff like file sharing.
- Some apps can tolerate some loss, like voice/video calling.
- Some apps need low latency transfer, stuff like games need a low delay.
- Some apps need a lot of throughput, like video streaming
- Some apps need security, stuff like bank apps.

When an app can make use of whatever throughput it can get, it is called \kw{elastic}. Taking a look at the internet, it only provides two transport layer services. \kw{TCP} and \kw{UDP}.

TCP provides reliable data transfer between processes, is flow controlled (TX wont overwhelm the RX), congestion controlled (RX will throttle TX when overloaded), its also a full-duplex connection. However TCP does not provide timing, security, or a minimum throughput guarantee.

UDP provides unreliable data transfer, it also doesnt provide flow/congestion control, timing, throughput guarantee, timing, etc.


## Web & HTTP

Now that we have the basics down, lets talk about webapges and how they are represented! Before we get into this section recall that a website is made up of several different \kw{objects} such as images, text, links, etc. Webpages are HTML files containing references to each of these objects, each of which are addressable with a URL, with a hostname and pathname to the file.

### An Overview of HTTP

\kw{Hyper-Text Transfer Protocol (HTTP)} is the web's application layer protocol, and it follows the client/server paradigm. Here the client would be a web browser (firefox, chrome, edge, etc.). The server here would be a web server that sends objects using the HTTP protocol in response to any requests.

HTTP uses TCP, the general flow of this connection is as follows:

1. Client *initiates* and creates a socket to the server on port 80
1. The server *accepts* the TCP connection from the client
1. HTTP messages are *exchanged* between server and client
1. The TCP connection is *closed*

HTTP is a *stateless* protocol, the server maintains no information about past-client requests, this is because this is much more simple. Note that an HTTP connection between a browser and a server is NOT the same as the TCP connection underneath.

### Persistent and Non-persistent HTTP

There are also two types of HTTP connections: \kw{Non-persistent HTTP (NP-HTTP)} and \kw{Persistent HTTP (P-HTTP)}. Non persistent HTTP involves opening and closing a TCP connection for each object requested, with only one object being exchanged per TCP connection. Persistent HTTP involves one TCP connection, but many objects can be exchanged serially over this connection.

Overall Non-persistent HTTP involves an extra \kw{round-trip-time (RTT)} per object just to establish the TCP connection! Overall non-persistent HTTP has a response time of 2 RTT's and the time needed for the server to transmit the file.

$$
\text{NP-HTTP Response Time} = 2 \text{RTT} + t_\text{trans}
$$

Most web servers now operate on persistent HTTP (HTTP 1.1) This elimates the extra RTT needed for each subsequent object.

### HTTP Messages

There are two types of HTTP Messages, one for a \kw{request} and another for a \kw{response}. These messages are sent with human readable ASCII encoding!

There are 4 types of request messages

1. GET - get an object
1. POST -  upload completed form data to server
1. HEAD - asks for a response identical to a GET, but without the response body
1. PUT - upload/replace an object to the server

There are 5 types of response messages, each with its own status code

1. OK (200) - looks good
1. MOVED PERMANENTLY (301) - requested file has moved location
1. BAD REQUEST (400) - Message not understood by server
1. NOT FOUND (404) - Requested Document not fouind on server
1. VERSION NOT SUPPORTED (505) - This HTTP version is not supported by the server

### Web Caches

A \kw{web cache} is essentially a proxy server that can act as both a client and a server. Instead of connecting directly to the main sever, clients connect to the cache and send requests/responses there. If the cache is being requested for an object that it does not have, it sends a request to the main server first, caches the object, and responds to the client. This means the next time this object is requested, the web cache directly sends the file to the host without involving the main server.

One important factor in calculations is the \kw{hit-rate}, this is the percentage of requests being sent to the cache, the remaining percentage is still handled by the main server.

Theres also a second-form of caching, where the client's browser is used. If the client has the latest file, then theres no point in retransmitting, but how can the client know if its the latest? The answer is through a \kw{CONDITIONAL GET}. Here the client specifies the date of the cached copy in an HTTP request, and the server responds with a 304 if their file is the latest version.

If the object has been modified since the last cached version, the server responds with the usual OK and then sends the data.

### HTTP 2

HTTP 2's main goal is to decrease delay in multi-object HTTP requests. It allowed for more flexibility for the server side in sending objects to the client. An important change here is that the transmission order of requested objects is not first-come first-serve, it is now based on a client-specified object priority. It can also push unrequested objects to the client. Furthermore objects are divided into frames, and these frames are scheduled to prevent head-of-line (HOL) blocking.

This frame division allows for different objects to be interleaved, which can allow for faster overall file sending, due to small files not being blocked by large files.

## Email

In this section were going to focus on the infrastructure of agents, servers and mailboxes. Were also going to examine the SMTP protocol.

As a service Email has three major componenets:

- User agents (outlook, gmail, etc)
- Mail servers (has a mailbox, message queue)
- SMTP (pushes messages from one mail server to another)

### SMTP

The SMTP protocol uses TCP to reliably transfer email messages from the client (sender server) to the server (reciever sever).
Sending an email has three phases of transfer, inbetween the opening/closing of the TCP connection.

1. Handshaking/Greeting (HELO)
1. SMTP transfer of messages
1. SMTP Closure

Email is really quite simple, its quite different from HTTP in the fact that it pushes data from client to server, rather than pull data from server to client like HTTP.

## Domain Name System

The \kw{Domain Name System (DNS)} is a way of identifying things on the web. Its essentially a dstributed database of IP adresses and name. Its implemented as a hierarchy of many \kw{name servers}. 

The DNS provides a number of different functions

- hostname to IP address translation
- host aliasing
- mail server aliasing
- load distribution (many IPs provide the same service, DNS rotates between these)

The DNS is decentralized for many reasons, a centralized DNS would create a single-point of failure, increase traffic volume, and tighter maintanance. Essentially a centralized DNS doesnt scale. The hierarchy of this DNS is as follows (from top-down)

1. Root DNS
2. Top Level Domain (TLD) such as .com, .org, servers
3. Authoritative (yahoo.com, amazon.com DNS servers)

When a local DNS server is sent a request, if it doesnt have the IP cached, it follows this chain of communication with the local DNS in between each step

1. Root DNS gives a list of TLDS possible for handling this website name
2. TLDS gives the IP address of the authoritative DNS
3. Then the authoritative DNS responds with the IP

This example above is called an \kw{iterative query}, if we eliminate the local DNS in between, the method is called \kw{recursive querying}.
