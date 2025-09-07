# Introduction & Review

This course deals with analysis and design of electronic circuits, to understand the basics of this course, we will need to learn to analyze
basic transistor and diode circuits, this will be reviewed below.

## The Diode

A \kw{diode} is shown in the circuit below.

\begin{center} 
\vspace{1cm} 
\begin{circuitikz}[american]
\draw (0,0) node[label=above:Cathode]{} to[diode, i=$i_D$, v=$v_D$] (0,-4) node[label=below:Anode]{};
\end{circuitikz} 
\end{center}

An ideal diode acts as a one-way current path that only allows flow from cathode to anode.

- When $v_D > 0$ the diode acts as a \kw{short-circuit} and is said to be \kw{forward-biased}
- When $v_D < 0$ the diode acts as an \kw{open-circuit} and is said to be \kw{reverse-biased}

The \kw{diode voltage, $v_D$} is defined as the voltage from anode to cathode:

$$
v_D = v_{\text{cathode}} - v_{\text{anode}}
$$

### The Constant Voltage-Drop Model

Diodes are \kw{non-linear} elements, they actually follow an exponential i-v curve, but this makes
manual analysis next to impossible, so in order to analyze circuits with diodes, we introduce the
\kw{constant voltage-drop model} where we assume that the diode voltage $v_D$ has a fixed value if the diode
is forward-biased, usually this value is assumed to be $0.7$ V. This means that

- When $v_D > 0.7$ the diode is forward-biased
- When $v_D < 0.7$ the diode is reverse-biased

Lets deal with a simple example using this model, lets find $v_R$ in the circuit below

\begin{center}
\vspace{1cm}
\begin{circuitikz}[american]
	\draw (0,0) node[ground]{} to[vsourcesin, l=$5V$] ++(0,2) to[diode, i=$i_D$, v=$v_D$] ++(6,0) to[resistor,l=$1k$, v=$v_R$] ++(0, -2) node[ground]{};
\end{circuitikz}
\end{center}

In order to solve diode circuits, we must follow the steps below:

1. Make a guess for each diode's biasing (forward, reverse)
2. Analyze the circuit as if the guesses are correct
3. Validate the guesses to see if they are correct based on the biasing conditions

For this circuit lets assume that the diode is forward-biased and write KVL

$$
v_{\text{src}} = v_D + v_R
$$
$$
v_{\text{src}} = v_D + 1k(i_D)
$$
$$
v_{\text{src}} - v_D = 1k(i_D)
$$
$$
i_D = \frac{v_\text{src} - v_D}{1k} = \frac{5 - 0.7}{1k} = 4.3 \text{mA}
$$

In this case, when guessing that our diode is forward-biased, our $i_D > 0$, so our guess was correct. And the circuit operates as we guessed with 4.3 mA flowing through it
If we assume that the diode is reverse-biased, we must validate that $v_D < 0.7$
### Biasing & Non-Linear Elements

Since we are often dealing with non-linear elements in this course, a big part is modelling how they respond to **small signals**
Since the i-v curve of a diode is exponential we must essentially find the point on the i-v curve where the diode is operating, this point is called a \kw{biasing-point} or \kw{bias}

Once we find this point, we can assume local-linearity of the i-v curve for a small enough signal.

### The Small Signal Model

In order to find out how we can model diodes with small signal fluctuations we must derive it ourselves
the exponential model of a diode can be written below.

$$
i_D = I_s \left[\exp{\left(\frac{v_D}{V_T}\right)} - 1 \right]
$$

Now lets suppose we add some fluctuations in the voltage and current $\Delta v_D$ and $\Delta i_D$ respectively

$$
i_D + \Delta i_D = I_s \left[\exp{\left(\frac{v_D + \Delta v_D}{V_T}\right)} - 1 \right]
$$

Lets also ignore the $1$ term since it can be insignificant for sufficiently large values of $v_D$

$$
i_D + \Delta i_D = I_s \left[\exp{\left(\frac{v_D + \Delta v_D}{V_T}\right)} \right]
$$

$$
i_D + \Delta i_D = I_s \exp{\left( \frac{v_D}{V_T} \right)} \exp{\left( \frac{\Delta v_D}{V_T} \right)}
$$

if $\Delta v_D$ is small we can use the fourier-series exapansion to approximate it: $\exp{\left(x\right) = 1 + x}$

$$
i_D + \Delta i_D = I_s \exp{\left( \frac{v_D}{V_T} \right)} \left[ 1 + \frac{\Delta v_D}{V_T} \right]
$$

$$
i_D + \Delta i_D = I_s \exp{\left( \frac{v_D}{V_T} \right)} + \Delta v_D \cdot \frac{I_s \exp{\left( \frac{v_D}{V_T} \right)}}{V_T}
$$

With our approximation from earlier we can sub in $i_D$ to get the following

$$
i_D + \Delta i_D = i_D + \frac{i_D}{V_T} \cdot \Delta v_D
$$

This means that 

$$
\Delta i_D = \frac{i_D}{V_T} \cdot \Delta v_D
$$

Giving us a simple linear small-signal model of a resistor, so during ac-analysis we can swap out our forward-biased diodes for resistors of value r_D

$$
r_D = \frac{V_T}{i_D} 
$$

### Small Signal Model: Example

Now lets do an example, where we need to find the diode voltage $v_D$

- $v_s = 10 + \sin{\omega t}$ V
- $R = 10$ k
- $V_T = 25$ mV

\begin{center}
\vspace{1cm}
\begin{circuitikz}[american]
	\draw (0,0) node[ground]{} to[vsourcesin, l=$v_s$] ++(0,2) to[resistor,l=$T$, v=$v_R$] ++(6,0) to[diode, i=$i_D$, v=$v_D$] ++(0, -2) node[ground]{};
\end{circuitikz}
\end{center}

As always we start with DC analysis to find the bias point of the diode.

Assume diode is forward-biased:

$$
v_s = v_R + v_D
$$

$$
v_s = R(i_D) + 0.7
$$

$$
i_D = \frac{v_s - 0.7}{R} = \frac{10 - 0.7}{10k} = 0.93 \text{mA}
$$

So our guess was correct since $i_D > 0$, this gives a bias-point of $(0.7 \text{V}, 0.93 \text{mA})$

Now lets look at the AC part, with the small signal model, replacing the diode with the resistor

$$
r_D = \frac{V_T}{i_D} = \frac{25 mV}{0.93 mA} = 27 \Omega
$$

\begin{center}
\vspace{1cm}
\begin{circuitikz}[american]
	\draw (0,0) node[ground]{} to[vsourcesin, l=$v_s$] ++(0,2) to[resistor,l=$T$, v=$v_R$] ++(6,0) to[resistor, i=$i_D$, l=$r_D$] ++(0, -2) node[ground]{};
\end{circuitikz}
\end{center}

This gives the AC part of our $v_D$ as

$$
v_D = \left(\frac{r_D}{r_D + R}\right) \cdot v_s
$$

$$
v_D = \left(\frac{27}{27+ 10k}\right) \cdot \sin{\omega t} = 2.7 m \cdot \sin \omega t \text{V}
$$

In order for the small signal model to be accurate we require that the small signal voltage fulctuation $v_D < V_T$
Here $2.7mV < 25mV$ so this is quite accurate of an approximation.

All in all our complete $v_D(t)$ becomes the sum of the DC and AC points:

$$
v_D (t) = 0.7 + 2.7 \text{m} \cdot \sin \omega t \, \text{V}
$$

### The Flowchart for Diode Analysis

Now with a bunch under our belt we can create a basic flowchart for diode circuit analysis

1. DC Analysis, make assumptions for each diode's operating mode
2. Validate the assumptions
	1. Forward-Biased $\rightarrow$ $i_D > 0$
	2. Reverse-Biased $\rightarrow$ $v_D < 0.7$
3. Find small-signal resistance $r_D = \frac{V_T}{i_D}$
4. AC analysis, replcae forward biased diodes with a resistor $r_D$ and reverse-biased with open circuits
5. Combine DC and AC analysis answers for the total voltages