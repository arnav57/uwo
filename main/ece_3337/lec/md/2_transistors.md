## Transistors

A \kw{transistor} is a three terminal device. At a high-level it functions as an electrically controlled switch. There are many flavours of transistors but the most basic ones are
the \kw{MOSFET} and the \kw{BJT}. MOSFET is an acronym for Metal Oxide Semiconductor Field-Effect Transistor, BJT is an acronym for Bipolar Junction Transistor. This chapter will 
cover the basics of each device, and basic circuit analysis with them.

### The MOSFET

The MOSFET is a type of transistor, and it features three terminals. The \kw{Gate $G$}, \kw{Source $S$}, and \kw{Drain $D$}. It also comes in two flavours NMOS and PMOS, the circuit symbols for
each are shown below, with their terminals labelled

\begin{center}\vspace{2cm}\begin{circuitikz}
	\draw (0,0) node[nmos](NMOS){NMOS};
	\draw (5,0) node[pmos](PMOS){PMOS};
	% terminal labels
	\draw (NMOS.G) node[label=left:Gate]{};
	\draw (PMOS.G) node[label=left:Gate]{};
	\draw (NMOS.S) node[label=below:Source]{};
	\draw (PMOS.S) node[label=above:Source]{};
	\draw (NMOS.D) node[label=above:Drain]{};
	\draw (PMOS.D) node[label=below:Drain]{};
\end{circuitikz}\end{center}

An easy way to differ the two is to use the arrow, the arrow always denotes the Source terminal, and the N in NMOS means "Not pointing inwards".

The Gate essentially acts as the transistors control input, The N and P in PMOS and NMOS signify the logic level required to close the switch, This means the following:

- NMOS transistors are "turned-on" when their gate voltage $v_G$ is high
- PMOS transistors are "turned-on" when their gate voltage $v_G$ is low

In reality its a little more complicated, but this makes it easy to remember which is which.

### Operating Regions of a FET

Unsurprisingly FETs are also non-linear devices, and they actually have a very similar approach to diodes for circuit analysis. We first make an assumption about the operating region of the device, these three regions, \kw{Cutoff}, \kw{Triode}, and \kw{Saturation} will be introduced now.

Note that for NMOS, $v_{th}$ is a positive value, and it is a negative value for PMOS, this is why we have the flipped sign convention here.

| Operating Region | Conditions (NMOS) | Conditions (PMOS) | Drain Current ($i_D$) |
| ---------------- | ----------------- | ----------------- | --------------------- |
| Cutoff           | $v_{GS} < v_{th}$ | $v_{GS} > v_{th}$ | $i_D = 0$
| | | | |
| Triode           | $v_{GS} > v_{th}$ and $0 \leq v_{DS} \leq v_{GS} - v_{th}$ | $v_{GS} < v_{th}$ and $0 \geq v_{DS} \geq v_{GS} - v_{th}$ | $i_D = k\left[ ( v_{GS} - v_{th} ) v_{DS} - \frac{1}{2}(v_{DS})^2 \right]$ | 
| | | | |
| Saturation | $v_{GS} > v_{th}$ and $v_{DS} > v_{GS} - v_{th}$ | $v_{GS} < v_{th}$ and $v_{DS} < v_{GS} - v_{th}$ | $i_D = \frac{1}{2} k ( v_{GS} - v_{th} )^2$ |

In the table above, the value $k$ is a predefined quantity in units of $\frac{\text{A}}{\text{V}^2}$
There is also another thing, the drain current $i_D$ should always be positive in Triode or Saturation Regions, this means that in NMOS current flows *out* of the source, and flows *into* the source for PMOS.

Note that the gate of a FET does not accept any current, in other words $i_G = 0$ in every region above. When designing electronic amplifiers, we often want to bias our FETs in the saturation region.

### DC Analysis of a FET

Lets start with a quick example of DC analysis with a NMOS amplifier, for this problem we will assume the following

 -  $k = 2 \,$  $\frac{\text{mA}}{\text{V}^2}$
 -  $v_{th} = 1$ V
 -  $R_1$ = 10M
 -  $R_2$ = 5M
 -  $R_D$ = 7.5k
 -  $R_S$ = 3k
 -  $R_L$ = 10k

\begin{center} \vspace{2cm} \begin{circuitikz}[scale=1.5, american]
	\draw (0,0) node[ground]{} to[vsourcesin, v<=$v_s$] ++(0,2) to[resistor, l=$R_{\text{sig}}$] ++(2,0) to [capacitor, l=$\infty$] ++(2,0) node[circ, label=above right:$v_G$](GATE){};
	\draw (GATE) to[resistor, l_=$R_1$] ++(0,3) node[vcc]{15 V};
	\draw (GATE) to[resistor, l=$R_2$] ++(0,-3) node[ground]{};
	\draw (GATE) to[short, i_=$i_G$] ++(1,0) node[nmos, anchor=G] (NMOS) {};
	\draw (NMOS.D) to[resistor, l=$R_D$, i<=$i_D$] ++(0,2.5) node[vcc]{15 V};
	\draw (NMOS.D) to[capacitor, l=$\infty$] ++(4,0) node[circ, label=above right:$v_L$]{} to[resistor, l=$R_L$] ++(0, -2) node[ground]{};
	\draw (NMOS.S) to[resistor, l=$R_S$] ++(0,-2.5) node[ground]{};
	\draw (NMOS.D) node[circ, label=below right:$v_D$]{};
	\draw (NMOS.S) node[circ, label=below right:$v_S$]{};
	\draw (NMOS.S) to[capacitor, l=$\infty$] ++(2,0) to ++(0,-1) node[ground]{};
\end{circuitikz} \end{center}

Lets start by finding the gate voltage, since $i_G = 0$ it acts as a voltage divider, we can formulate a simple expression for it. Note that we can ignore everything on the other side of the infinite capactiors, as they will block all DC signals, these capacitors will come into play when we go through AC analysis

$$
	v_G = \frac{R_2}{R_1 + R_2}\cdot(15) = 5 \text{V}
$$

We can also find the source voltage if we know the drain current

$$
	v_S = R_s i_D = 3(i_D)
$$

This means that our gate-source voltage $v_{GS}$ can be found as follows:

$$
v_{GS} = v_G - v_S = \frac{R_2}{R_1 + R_2}\cdot(15) - R_s i_D = 5 - 3(i_D)
$$

Lets assume saturation and use the drain-current equation from the table above, plugging in $k=2$ here as well:

$$
i_D = \frac{1}{2} k ( v_{GS} - v_{th} )^2 = ( 5 - 3(i_D) - 1)^2
$$

$$
0 = 16 - 25(i_D) + 9(i_D)^2
$$

Solving this gives two solutions:

- $i_D = 1$ mA
- $i_D = 1.78$ mA

Now we must use the conditions from the table above to see which is correct. Lets quickly rewrite the terminal voltage relations:

- $v_G = 5$
- $v_S = 3(i_D)$
- $v_D = 15 - 7.5(i_D)$

We must choose an answer that satifies the following

- $v_{GS} > v_{th}$
- $v_{DS} > v_{GS} - v_{th}$

The correct answer here is $i_D = 1$ mA as the other answer doesnt satisfy both inequalities above.

This means that we have found the DC Biasing point of our MOSFET, and since our conditions are both satisfied with $i_D = 1mA$ we are certain that our initial guess of the operating region is correct.

### Small Signal Models of a MOSFET

There are two versions of the small-signal model of a MOSFET, the \kw{pi-model} and the \kw{T-model}. Both are equivalent, but analysis might be easier with one rather than another.

These models require two parameters for full use with the early-effect resistance:

$$
g_m = \frac{2i_D}{v_{GS} - v_{th}}
$$

$$
r_o = \frac{V_A}{i_D}
$$

The Pi Model is shown below

\begin{center} \vspace{2cm} \begin{circuitikz}[american]
	\draw (0,0) node[ocirc, label=above left:G] (GATE) {} to ++(3,0);
	\draw (GATE)++(3,0) to[open, v=$v_{GS}$] ++(0,-3) -| ++(1,-0.5) node[ocirc, label=below:S] (SOURCE) {};
	\draw (SOURCE)++(0,0.5) to ++(1,0) to[controlled current source, invert, l_=$g_m v_{GS}$] ++(0, 3) to ++(5,0) node[ocirc, label=above right:D](DRAIN){};
	\draw (DRAIN)++(-2,0) to[resistor, l=$r_o$] ++(0, -3) to[short] ++(-3,0);

\end{circuitikz} \end{center}

