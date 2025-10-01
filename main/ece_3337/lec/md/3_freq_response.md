# Frequency Response

## Amplifier Behaviour

### Transfer Function of a Transistor Amplifier

The typical transfer function of an amplifier has \kw{band-pass} characteristic, This means that the \kw{transfer function $H(s)$} can be represented as a aggregation as shown below:

$$
H(s) = A_M \cdot F_L (s) \cdot F_H (s)
$$

Where,

- $A_M$ is the midband-gain of the amplifier (found through DC + small signal analysis assuming caps are shorts)
- $F_L (s)$ is the lower-band behaviour (typically high-pass)
- $F_H (s)$ is the higher-band behaviour (typically low-pass)

We should also note that since this is a band-pass, there are both an upper and lower cutoff (3 dB) frequency.

- The \kw{lower 3 dB frequency} is \kw{$f_L$}, it is present in $F_L(s)$ 
- The \kw{upper 3 dB frequency} is \kw{$f_H$}, it is present in $F_H(s)$

The region left of $f_L$ is called the \kw{lower-band}, and the region right of $f_H$ is called the \kw{higher-band}, lastly the region in between is called the \kw{mid-band}. At the midband, the 
transfer functions $F_L$ and $F_H$ approach unity, giving the midband-gain of $A_M$.

The span of the mid-band is said to be the \kw{bandwidth, $\psi$} of the amplifier, and it can be found with

$$
\psi = \left| f_H - f_L \right|
$$

Often in these amplifier designs, one can introduce a trade-off between gain and bandwidth. So to measure the quality of an amplifier we introduce the \kw{gain-bandwidth product GBW}
Which is the midband-gain multiplied by the bandwidth

$$
\text{GBW} = \psi \cdot \left| A_M \right|
$$

### Low, Middle, and High Frequency Analaysis

In order to find this midband-gain $A_M$ we analyze the amplifier equivalent small-signal circuit, with the assumptions that the coupling and bypass capacitors act as perfect 
short circuits, and that the internal parasitic capacitances of the transistor are acting as perfect open circuits.

For finding the low-frequency behaviour $F_L$ the overall behaviour can be approximated as $H_L(s) \approx H(s)$ shown below, due to the negligible impact of $F_H$

$$
H_L(s) = A_M F_L(s)
$$

Analysis of lower-band behaviour we must take into account only the non-parasitic capacitances, as these will have a non-negligible higher-impedance at lower frequencies, But we can still assume that the 
internal parastic capactances are still treated as perfect open-circuits.

For the high-frequency behaviour, once again we can approximate it as $H_H (s) \approx H(s)$

$$
H_H (s) = A_M F_H (s)
$$

Here we must take into account the internal parasitic capacitances, as they are now no-longer negligible. However every other capacitor can be treated ass a perfect short-circuit

### The Short Circuit Time Constant Method

\newcommand{\sct}{SC-$\tau$}

This method is a simpler way of finding the approximate behaviour through finding the dominant pole, $\omega_L = 2 \pi f_L$ of $F_L$. It works by approximating it as below. From here onwards
This method will be referred to as \sct

*Note:* This method works best with real poles, not with complex-conjugate poles, Here we only have RC circuits, which all have real-poles

$$
F_L (s) \approx \frac{s}{s + \omega_L}
$$

To estimate the dominant-pole, we analyze the low-frequency equivalent circuit (parastic caps are open, all other caps remain) and analyze each capacitor one at a time, setting all other capacitors
to short-circuits. While analyzing each capacitor we must determine the resistance it sees in total on either side, and add both sides up.

$$
	R_{\text{cap}} = R_{\text{LHS}} + R_{\text{RHS}}
$$

Doing this for each capacitor, we can find each capacitor's time constant

$$
	\tau = \frac{1}{RC}
$$

Then we can add all of the time constants up, to obtain an approximation of $\omega_L$

$$
F_L(s) = \frac{s}{s+\omega_L}
$$

Where,

$$
	\omega_L = \sum_{i} \tau_i = \sum_{i} \frac{1}{R_{C_i}C_i}
$$

### The Open Circuit Time Constant Method

\newcommand{\oct}{OC-$\tau$}

Similarly to \sct, we can use the Open circuit alternative to determine behaviour at high-frequency, once again we approximate $F_H$ here through the dominant pole $\omega_H = 2 \pi f_H$
This method also only works best with purely real poles. Going forward this method will be referred to as \oct

$$
	F_H (s) \approx \frac{1}{1 + \frac{s}{\omega_H}}
$$

To estimate the dominant-pole we analyze the high-frequency circuit (parastic caps present, other caps are all shorts) and do the exact same thing as in \sct. We find each capacitors time-constant

$$
	\tau = \frac{1}{RC}
$$

But note that we have a reciprocal term in our approximate transfer function here, so we must add the reciprocals of the time-constants in this case to obtain an approximation of $\omega_H$

$$
F_H(s) = \frac{1}{ 1 + \frac{s}{\omega_H}}
$$

Where,

$$
	\omega_H = \sum_{i} \frac{1}{\tau_i} = \sum_{i} R_{C_i}C_i
$$


### Unity Gain Frequency

Another way to measure the HF operationg of a transistor amplifier is the \kw{unity gain frequency $f_T$}, this is also known as the \kw{transition frequency}. Unsurprisingly this is defined
as the frequency at which the short-circuit current gain of the common-source or common-emitter amplifier becomes unity (1) 

The formulas are given below for the MOSFET and BJT respectively. The higher this value, the better the amplifier.

\begin{equation}
f_T = \frac{g_m}{2\pi \left( C_{gs} + C_{gd} \right)}
\end{equation}

\begin{equation}
f_T = \frac{g_m}{2\pi \left( C_{\pi} + C_{\mu} \right)}
\end{equation}

### Source Exchange

Often times during HF analysis we want as simple of a circuit as possible, so we can easily deal with things. In order to do this
we put a box around the small signal model of a transistor, and lump together the base/gate side, and the load side. into its own elements
This will be shown in the examples later in this chapter.

### Millers Theorem

For the common source amplifier, calculating the HF pole due to $C_{gd}$ is challenging. So we introduce
\kw{Millers Theorem} which helps us to deal with the bridging capacitances such as $C_{gd}$ and $C_{\mu}$.

The basic idea of Millers Theorem comes into play when we have some capacitor $Z$, we can essentially break it up into
two separate capacitances $Z_1$ and $Z_2$.

After this  is done, you can use \oct on both sub-circuits to find the resistance seen by each cap, and add them together at the end.
