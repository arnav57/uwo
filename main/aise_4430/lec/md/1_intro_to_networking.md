# Introduction to Networking

## What is the Internet

The \kw{internet} is essentially billions of connected computing devices, the internet features the following things:

- \kw{Hosts} - end systems that run apps at the internet's edge
- \kw{packet switches} - forward *packets* of data to routers and switches
- \kw{communication-links} - fiber, copper, radio, satellite all featuring a *bandwidth*
- \kw{Networks} - collections of devices, routers and links, managed by some organization

As such we can say that the internet is a network of networks featuring a bunch of
interconnected ISPs. These connections often feature protocols, which are a set of rules
based on how to communicate things.

The internet can also be thought of as a sort of *infrastructure* that provides services
to applications such as the web, streaming, multimedia, teleconferencing, email, etc.
The internet essentially provides a \kw{programming interface} to distributed applications

## What is a protocol?

All communication happens between computers, and this communication is governed by a 
\kw{protocol}, which defines the format, order of messages sent, and actions taken on message transmission and reception.

## A closer look

At the local level, one access ISP can feature many networks, such as school, a home, a company, etc.
Along with cell phone services. But at the internet level we have *millions* of ISPs, how can we connect them together?

The idea is to have a few global transit ISPs, that connect together, this forms a sort of *central core* of the internet. Furthermore, \kw{content provider networks} such as Google Microsoft, or Amazon might run their own network to bring services closer to end users.

## Layering

The internet is quite a complex system, and layering it properly can help to understand it better. Overall from top to bottom, these are the layers of the internet, described by the OSI model of computing

1. Application Layer
	- Supports network apps, IMAP, SMTP, HTTP
2. Transport Layer
	- process to process data transfer TCP, UDP
3. Network Layer
	- routing of data from source to destiation, IP, routing protools
4. Link Layer
	- Data transfer between neighbourinig network elements (Etheret, Wifi, etc)
5. Physical Layer
	- Physical Bits transmitted across a wire, deals with maintaining low BER as possible across several physical communication mediums.

# Network Performance

Networks consist of devices sending packets back and forth to each other, understanding this will help us determine and characterize a networks performance

## Routers

Routers represent a interchange, on the road a packet takes, it essentially sends the packet to the right place based on where it needs to go.

\renewcommand{\tt}[1]{t_\text{#1}}

We can model a router as below:

1. A flop + logic stage that accepts the data and does some processing on the packet $\tt{proc}$
2. A FIFO that queues the packet with queueing delay, $\tt{queue}$
3. A TX that sends the packet out after a delay $\tt{trans}$
4. A channel where the packet propagates through, reaching the destination after $\tt{prop}$

Note that our FIFO is a fixed length, and incoming packets can be dropped if the FIFO is full! This packet might be resent by the previous node, or by the system or not at all.

## Router Delay

Overall the total time spent at a node (router) before reaching the other node is defined below, sometimes this quantity is also referred to as $\tt{nodal}$. Each term in this expression below will be explained further.

$$
\tt{router} = \tt{proc} + \tt{queue} + \tt{trans} + \tt{prop}
$$

The flop stage, resulting in $\tt{proc}$ usually involves checking for bit errors, and algorithms for determining the proper destination, all of this typicall takes less than a millsecond

The FIFO stage results in a delay $\tt{queue}$ and it depends on the current usage of the FIFO, supposing we have a transmission rate of $R$ bits per second, and each packet in the FIFO has a length of $L$ bits,
this queueing delay becomes dependent on $n$ the number of packets before the current one in the FIFO, if the FIFO is empty when the packet arrives, $n$ is equal to 0, essentially this is the delay to transmit all packets before the one of interest:

$$
\tt{queue} = n \cdot \frac{L}{R} = n \cdot \tt{trans}
$$


The Tx ends up resulting in $\tt{trans}$, if we take our variables from earlier, $R$ for transmission rate in bits per second, and $L$ for packet length, we can see that the transmission delay is as described earlier in the FIFO stage delay.

$$
\tt{trans} = \frac{L}{R}
$$

Lastly, we have the propagation delay* of the packet through the chosen channel. We can describe this delay with $d$ which is the length of the physical link, and $s$ which is the propagation speed through this link.
Typically we assume $s \approx 2 \text{E} 8$. Altogether we get:

$$
\tt{prop} = \frac{d}{s} = \frac{d}{2 \times 10^8}
$$

