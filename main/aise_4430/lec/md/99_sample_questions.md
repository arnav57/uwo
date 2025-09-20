# Sample Questions

## Chapter 1

### Problem 1

Consider two hosts, A and B, connected by a single link of rate $R$ bps. Suppose that the two hosts are
separated by $m$ meters, and suppose the propagation speed along the link is $s$ meters/s. Host A is to5. If $\tt{prop} > \tt{trans}$, at $t = \tt{trans}$ where is the first bit?
send a packet of size $L$ bits to host B.

1. Express $\tt{prop}$ in terms of $m$ and $s$

From the notes earlier we know 
$$
\tt{prop} = \frac{m}{s}
$$

2. Determine transmission time, $\tt{trans}$ of the packet in terms of $L$ and $R$

$$
\tt{trans} = \frac{L}{R}
$$

3. Ignoring queueing and processing times, what is the end-to-end delay?

$$
\tt{router} = \tt{trans} + \tt{prop} = \frac{L}{R} + \frac{m}{s}
$$

4. Suppose host A begins transmission at $t = 0$, at $t = \tt{trans}$ where is the last bit of the packet? 

Time to transmit the whole packet is $\tt{trans}$ so after this time, the last bit will be at the start of the channel/physical link

5. If $\tt{prop} > \tt{trans}$, at $t = \tt{trans}$ where is the first bit?

Here this means that the propagation delay for a single bit, takes longer than transmission of the entire packet, thus the first bit would be on the wire but not reached host B yet

6. If $\tt{prop} < \tt{trans}$, at $t = \tt{trans}$ where is the first bit?

Here this means that the propagation delay for each bit takes less time than transmission of the whole packet, thus the first bit would have reached host B by now, since the entire packet has been transmitted at $t = \tt{trans}$ and propgation time is less than this.

### Problem 2

In this problem we consider sending voice from Host A to Host B over a packet-switched network (for example, Internet phone). Host A converts analog voice to a digital 64 kbps bit stream on the fly. Host
A then groups the bits into 48-byte packets. There is one link between Host A and B; its transmission rate is 1 Mbps and its propagation delay is 2 msec. As soon as Host A gathers a packet, it sends it to
Host B. As soon as Host B receives an entire packet, it converts the packet’s bits to an analog signal.
How much time elapses from the time a bit is created (from the original analog signal at Host A) until
the bit is decoded (as part of the analog signal at Host B)?

From the question we have:
$$
A \rightarrow \text{NODE} \rightarrow B
$$

at A we have a 64Kbps bit-stream, grouped into packets of width 48 B.

so the total number of bits in a packet is, and the first packet takes this long to generate completely

$$
\tt{first packet} = \frac{48 \times 8}{64 \text{K}} = 6\text{ms}
$$

Then we need to consider the nodal time

$$
\tt{nodal} = \tt{trans} + \tt{prop} = \frac{48 \times 8}{1 \times 10^6}
$$

The total time is then:

$$
\tt{total} = \tt{first packet} + \tt{nodal}
$$

### Problem 3

Consider the queuing delay in a router buffer (preceding an outbound link). Suppose all packets are L
bits, the transmission rate is R bits, and that N packets simultaneously arrive at the buffer every LN/R
seconds. Find the average queuing delay of a packet. (Hint: the queuing delay for the first packet is
zero; for the second packet L/R; for the third packet 2L/R. the Nth packet has already been transmitted
when the second batch of packets arrives)

The queuing delay for any packet is dependent on $N$

$$
\tt{queue} = N\cdot\frac{L}{R}
$$

If $N$ packets arrive every $\frac{NL}{R}$ seconds, the average queing delay for a packet is the following:

$$
\tt{queue, avg} = \sum_i \tt{queue, packet i} \cdot \frac{1}{N}
$${

$$
\tt{queue, avg} = \frac{1}{N} \cdot \left( \frac{L}{R} \right)\left[ 0 + 1 + 2 + \dots + N-1 \right]
$$

This simplifies to

$$
\tt{queue, avg} = \frac{1}{N} \cdot \frac{N(N-1)}{2} \cdot \frac{L}{R} = \frac{N-1}{2} \cdot \frac{L}{R}
$$

### Problem 4

Suppose two hosts A and B are seperated by 10 thousand km, and are connected by a direct link of R = 1 Mbps. Suppose to propagation speed is 2.5 E 8 m/s

1. Calculate the bandwith-delay product

$$
R \times \tt{prop} = 1 \text{M} \times \frac{10000\text{E3 m}}{\text{2.5E8 m/s}} 
$$

2. Suppose we are sending a large file 400,000 bits wide from A to B, what is the maximum number of bits that will be in the link at any given time?

The max number of bits on the link at any given time can be found by remembering that distance = speed $\times$ time, here the speed is the propagation speed of a bit, and the time is the transmission time for one bit.

therefore we get this one expression for the width of a bit:

$$
l_\text{bit} = \frac{s}{R}
$$

Where $s$ is bit propagation speed of a single bit in m/s, and $R$ is the transmission bandwidth in bps

Then we can divide the link length by the bit-length to get the total number of bits on the link at any given time.

$$
n_\text{bits} = \frac{d}{l_\text{bit}}
$$

### Problem 5

Suppose users share a 3 Mbps link. Also suppose that each user requires 150 kbps when transmitting, but each transmits only 10 percent of the time

1. When circuit switchinng is used, how many users can be supported?

For circuit switching the number of users supported $q$ can be found here

$$
q_\text{circuit switching} = \frac{R_\text{link}}{R_\text{user transmit} = \frac{3000}{150} = 20}
$$

2. For the remainder of this problem suppose packet switching is used, find the probability that a given user is transmitting

Each transmits 10% of the time, this is given from the question

3. The probability that $n$ users out of all $m$ users are simultaneously transmitting on a link, when each user has a $p$ chance of transmitting is

$$
P_n = m \choose n \times p^n \times (1-p)^{m-n}
$$

Where,

$$
m \choose n = \frac{n!}{k! \cdot (n-k)!}
$$

The probablity that there are 10 users out of 15 transmitting simultaneously is given by the below expression. For part c) we suppose 120 users total, what is the probabiliity that 55 are transmitting at once

$$
P_{10} = 120 \choose 55 \times (0.1)^{55} \times (0.9)^{120-55}
$$

the chance that there are 55 or more users transmitting is
$$
1 - \sum_{n=0}^{55} 120 \choose n \cdot (0.1)^n \cdot (0.9)^{120-n}
$$