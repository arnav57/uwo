## Sample Problems Set 6

This problem set deals with Link Layer protocols such as CSMA/CD Ethernet

### Problem I

\question

Recall that with the CSMA/CD protocol, the adapter waits k $\cdot$ 512 bit times after a collision, where K is 
drawn randomly. For K = 100, how long does the adapter wait until returning to Step 2 for a 10 Mbps 
Ethernet? For a 100 Mbps Ethernet? 

\answer

First we need to define what a \kw{bit-time} is. This is the amount of time it takes to transmit a single bit onto the link. More specifically:
$$
	t_\text{bit} = \frac{1}{R}
$$

In this case our 10Mbps rate has a $t_\text{bit} = 100 ns$ and our 100 Mbps rate has a $t_\text{bit} = 10 ns$
With CSMA/CD we wait  for K times 512 bit times before retransmitting, where K is randomly chosen. Here the problem fixed K = 100, thus our wait times are:

$$
t_\text{wait, 10Mbps} = 51200 \cdot 100 ns = 5.12 ms
$$

$$
t_\text{wait, 100Mbps} = 51200 \cdot 10 ns = 512 \mu s
$$

### Problem II

\question 

Suppose nodes A and B are on the same 10 Mbps Ethernet segment, and the propagation delay between 
the two nodes is 225 bit times. Suppose node A begins transmitting a frame and, before it finishes, 
node B begins transmitting a frame. Can A finish transmitting before it detects that B has transmitted? 
Why or why not? If the answer is yes, then A incorrectly believes that its frame was successfully 
transmitted without a collision

*Hint*: suppose at time t = 0 bit times, A begins transmitting a frame. In the worst case, A transmits a 
minimum-sized frame of 512+64 bit times. So A would finish transmitting the frame at t = 512 + 64 bit 
times. Thus the answer is no, if B’s signal reaches A before bit time t = 512 + 64 bits. In the worst case, 
when does B’s signal reach A? 

\answer

Here the hint mentions that the minumum sized frame is 512 + 64 = 576 bits, which takes 576 bit times to transmit, and an extra 225 bit times to propagate to node B. So lets look at this from A's perspective.

Suppose A transmits at $t = 0$, it will finish transmitting at $t = 576$ and due to pipelining the first transmitted bit would arrive at node B at $t = 225$. There are two distinct cases here:

If node B transmits at $t = 0$ as well, the same holds true, so if both A and B transmit at $t = 0$ they would both sense a collision at $t = 225$ after the first bit propagates to the other node. This is the *best* case.

The latest possible time node B could transmit is at $t = 224$, one bit time before the message from A reaches B. If this occurs, the total time it takes for node B to transmit would be $t = 224 + 225 = 249$ for the first bit to propagate and reach node A. This is is smaller than the total time it would take for A to finish transmitting. This is the *worst* case.

So in this case node A will never incorrectly classify its message as in the worst case scenario the first bit from node B arrives earlier than the entire transmission time for node A. In other words, if A doesnt detect another node transmitting during its own transmission, it means no other host has begun transmitting.

### Problem III

\question

Consider a 100 Mbps 100BaseT Ethernet. In order to have an efficiency of 0.5, what should be the 
maximum distance between a node and the hub? Assume a frame length of 64 bytes and that there are 
no repeaters. 

Does this maximum distance also ensure that a transmitting node A will be able to detect 
whether any other node transmitted while A was transmitting? Why and why not? How does your 
maximum distance with the actual 100 Mbps standard? 

\answer 

Recall from the slides the efficiency equation, Here we desire $\eta = 0.5 = 50\%$

$$
\eta = \frac{1}{1 + 5\left(\frac{t_\text{prop}}{t_\text{trans}}\right)}
$$

We can easily find $t_\text{trans}$ for transmitting the 64 byte frame + 1 byte of header as shown below.

$$
t_\text{trans} = \frac{L}{R} = \frac{65 \times 8}{100 \text{M}} = 5.76 \mu \text{s}
$$

With this quantity we can plug this value into the efficiency equation to solve for $t_\text{prop}$.

$$
t_\text{prop} = \left( \frac{1}{\eta} - 1 \right) \cdot \frac{t_\text{trans}}{5} = 1.152 \mu \text{s}
$$

We also assume that the propagation speed $s = 1.8\cdot10^8$ m/s, then we can solve for the distance $d$

$$
t_\text{prop} = \frac{d}{s} 
$$

$$
d = s \cdot t_\text{prop} = 1.8 \cdot 10^8 \cdot 1.152 \mu \text{s} = 207.36 \text{m}
$$

Thus we should have a physical distance of 207.36 meters for an efficiency of 50% in this link. It is close to the 100 Mbps Ethernet Standard value of 200m.

The second part of this question asks if node A is transmitting, it can detect any other nodes are transmitting at the same time. For this we require that the below holds true.

$$
t_\text{trans} > 2 \cdot t_\text{prop}
$$

In our case it certainly does hold true, so we can be certain that no matter what, A will be able to detect if another node is transmitting during its own transmission, and will correctly classify a collision.

### Problem IV

\question

A token-ring LAN interconnects M stations using a star topology in the following way. All the input 
and output lines off the token-ring station interfaces are connected to a cabinet where the actual ring is 
placed. Suppose that the distance from the each station to the cabinet is 100 meters and the ring latency 
per station is eight bits. Assume that frames are 1250 bytes and that the ring speed is 25 Mbps. 

a) What is the maximum possible arrival rate that can be supported if stations are allowed to
transmit an unlimited number of frames/token?

b) What is the maximum possible arrival rate that can be supported if stations are allowed to
transmit 1 frame/token using single-frame operation?

\answer

In a token ring, each node basically sends data if it has any, and then passes on a token afterwards

Lets start with part (a), here if stations are allowed to transmit at max speed for unlimited time, the max rate is 25 Mbps because one station might eat up the entire channels bandwidth, leaving the other channels eternally waiting and not transmitting the token, so the arrival rate is the channel datarate, 25 Mbps.

For part (b) each station will get the token, send 1 frame of data, and then pass the token onwards. To find the arrival rate we need to find the time it takes for an entire traversal of the network topology.

In other words each station will experience the following delays:

1. cabinet to station prop delay (receiving the data)
2. processing delay (processing the data, question says 8 bit times)
3. transmission delay (sending the data onto the link)
4. station to cabinet prop delay (sending the data)

We can calculate these delays for each station

$$
t_\text{trans} = \frac{L}{R} = \frac{1250 * 8}{25 \text{M}} = 400 \mu \text{s}
$$

$$
t_\text{prop} = \frac{d}{s} = \frac{100}{3 \cdot 10^8} =  333.333 \text{ns}
$$

$$
t_\text{proc} = \frac{8}{25 \text{M}} = 120 \text{ns}
$$

Now we can calculate the time required per station:

$$
t_\text{station} = t_\text{prop} + t_\text{proc} + t_\text{trans} + t_\text{proc} = 400.7 \mu \text{s}
$$

Then a whole cycle around the ring of 5 stations is simply $5 \times t_\text{station}$
Which takes approx 2 ms, and in this time we transmit one frame of 1250 bytes.

This means the arrival rate in general for a token ring with $M$ stations is

$$
R_\text{ring} = \frac{L}{M\cdot t_\text{station}}
$$

Using this formula in our case gives the following arrival rate:

$$
R_\text{ring} = \frac{1250 \cdot 8}{2 \text{ms}} \approx 5 \text{Mbps}
$$

This value is very close to the equation $R_\text{ring} = \frac{R}{M}$, Its only exactly the same here because i approximated the total value for $4 \times t_\text{station}$


### Problem V

\question 

Consider six stations that are all attached to three different bus cables. The stations exchange fixed-size 
frames of length 1 second. Time is divided into slots of 1 second. When a station has a frame to 
transmit, the station chooses any bus with equal probability and transmits at the beginning of the next 
slot with probability p.  

Find the value of p that maximizes the rate at which frames are successfully transmitted.

\answer

In order to do this we require basic probability and calculus :( First lets analyze this first with probability.

We have 6 stations here, each station has the following basic stats.

- There is a $\frac{p}{3}$ chance that the station transmits onto bus A
- There is a $1 - \frac{p}{3}$ chance that the station doesnt transmit onto bus A (chooses B or C instead)

We have 6 six stations in total, so the probability that station 1 transmits onto bus A, is composed of the following

1. station 1 transmits onto bus A
1. AND stations 2-6 do not transmit onto bus A 

We can write this mathematically as shown below

$$
P_\text{1 on A} = (p) \cdot \left(1 - \frac{p}{3}\right)^5
$$

this probabilty can be repeated for the remaining stations 2 - 6, to get the same expression as the one above. Thus the total probability that any station successfully transmits on bus A is 6 times the previous value

$$
P_\text{success, bus A} = 6 \cdot P_\text{1 on A}
$$

here since the entire system is symmetrical we have the same probabilty for a success on bus B and bus C as well. Regardless we have the probabilty as a function of $p$ so we can now do the basic calculus optimization thing

$$
\frac{dP_\text{success, bus A}}{dp} = 6 \cdot \frac{d}{dp} \left[ (p) \cdot \left(1 - \frac{p}{3}\right)^5 \right]
$$

Painful product rule here

$$
\frac{dP_\text{success, bus A}}{dp} = 6 \cdot \left[ \left(1 - \frac{p}{3}\right)^5 - \frac{5}{3}\cdot(p)\left(1 - \frac{p}{3} \right)^4  \right]
$$

Now we do algebra sadly

$$
\frac{dP_\text{success, bus A}}{dp} = 6  \left(1 - \frac{p}{3}\right)^4 \left( \left(1 - \frac{p}{3}\right) - \frac{5p}{3}  \right)
$$

We set this equal to 0 and solve for possible values of $p$ here, which occurs when any of the factors are equal to 0. This means we can enumerate solutions to this equation above as $p_n$


$p_0$ can be found by setting the first factor equal to 0

$$
0 = \left( 1 - \frac{p_0}{3} \right)
$$
$$
p_0 = 3
$$

$p_1$ can be found by setting the second factor equal to 0

$$
0 = \left(1 - \frac{p_1}{3}\right) - \frac{5p_1}{3}
$$
$$
0 = \left( 1 - \frac{6p_1}{3} \right)
$$
$$
p_1 = \frac{1}{2}
$$

we cannot have a probabilty value of $p$ = 3, thus we exclude it as a valid solution, leaving $p$ = 0.5 as the optimal solution here to maximize the probability of successful transmissions on cable A, B, or C from any of the six stations.
