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
 -  $V_A = 100$ V
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

These models require two parameters for full use with the early-effect resistance $r_o$, in problems where we neglect it, we can replace this resistor with an open-circuit:

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

The T-model is also shown here:

\begin{center} \vspace{2cm} \begin{circuitikz}[american]
	\draw (0,0) node[ocirc, label=left:G] (GATE) {} to[short, i=$i_G$] ++(3,0);
	\draw (GATE)++(3,0) to[resistor, l=$\frac{1}{g_m}$] ++(0,-3) to ++(0,-1) node[ocirc, label=below:S] (SOURCE) {};
	\draw (GATE)++(3,3) to[controlled current source, l=$g_m v_{GS}$] ++(0,-3);
	\draw (GATE)++(3,4) node[ocirc, label=above:D] (DRAIN) {} to ++(0,-1);
	\draw (DRAIN)++(0,-1) to ++(3,0) to[resistor, l_=$r_o$] ++(0,-6) to ++(-3,0);
\end{circuitikz} \end{center}

### Example: Small Signal Operation of a MOSFET

Lets continue our previous example, extending it to include small signal operation. Recall that we found the following bias point after DC analysis

- $i_D = 1$ mA
- $v_{GS} = 2$ V

We always start by finding the small signal parameters $g_m$ and $r_o$

$$
g_m = \frac{2i_D}{v_{GS} - v_{th}} = \frac{2m}{2 - 1} = 2 \frac{\text{mA}}{\text{V}}
$$
$$
r_o = \frac{V_A}{i_D} = \frac{100}{1m} = 100 k \Omega
$$

Now we can use either model to analyze the circuit during AC fluctuations, this involves replacing all caps with short-circuits. We will be using the $\pi$-model for this example

\begin{center} \vspace{2cm} \begin{circuitikz}[american]

	% PI MODEL
	\draw (0,0) node[ocirc, label=above left:G] (GATE) {} to ++(3,0);
	\draw (GATE)++(3,0) to[open, v=$v_{GS}$] ++(0,-3) -| ++(1,-0.5) node[ground, label=left:S] (SOURCE) {};
	\draw (SOURCE)++(0,0.5) to ++(1,0) to[controlled current source, invert, l_=$g_m v_{GS}$] ++(0, 3) to ++(8,0) node[ocirc, label=above right:D](DRAIN){};
	\draw (DRAIN)++(-5,0) to[resistor, l=$r_o$] ++(0, -3) to[short] ++(-3,0);

	% ACUTAL AMPLIFIER
	\draw (GATE) to[short] ++(-1,0) to[resistor, l=$R_{\text{sig}}$] ++(-3,0) to[vsourcesin, v=$v_s$] ++(0,-3.5) node[ground]{};
	\draw (GATE)++(-1,0) to[resistor, l=$R_1 || R_2$] ++(0, -3.5) node[ground] {};
	\draw (DRAIN)++(-3,0) to[resistor, l=$R_D$] ++(0,-3.5) node[ground] {};
	\draw (DRAIN)++(-1,0) to[resistor, l=$R_L$, i=$i_o$, v=$v_o$] ++(0,-3.5) node[ground] {};

\end{circuitikz} \end{center}

Now lets start by finding in input and output resistance $R_{\text{in}}$ and $R_{\text{out}}$ Usually there are arrows to denote where each starts from, in this case our input resistance
starts from after $R_{\text{sig}}$ and our output resistance starts before $R_L$.

This gives

$$
R_{\text{in}} = R_1 || R_2
$$
$$
R_{\text{out}} = r_o || R_D
$$

Next lets find the signal-voltage to gate-source voltage ratio, this is a simple voltage divider

$$
v_{GS} = \frac{R_1 || R_2}{R_1 || R_2 + R_{\text{sig}}} \cdot v_s = \frac{R_\text{in}}{R_{\text{in}} + R_{\text{sig}}} \cdot v_s
$$
$$
\frac{v_{GS}}{v_s} = \frac{R_\text{in}}{R_{\text{in}} + R_{\text{sig}}}
$$

Next lets fine the output voltage (voltage across $R_L$) to gate-source voltage ratio, We know that we can group the three resistors into one, and thus the current flowing through all three must add up to $g_m v_{GS}$
This gives us our expression

$$
v_o = 0 - i_D \cdot \left( r_o || R_D || R_L \right) = - g_m v_{GS} \cdot \left( r_o || R_D || R_L \right)
$$
$$
\frac{v_o}{v_{GS}} = -g_m \left( r_o || R_D || R_L \right)
$$

Altogether we can find the total signal to output voltage gain, by combining the gains of both stages above. This gives us the total-ac-gain of the amplifier.
$$
\frac{v_o}{v_s} = \frac{v_o}{v_{GS}} \cdot \frac{v_{GS}}{v_s} = -g_m \left( r_o || R_D || R_L \right) \cdot \frac{R_\text{in}}{R_{\text{in}} + R_{\text{sig}}}
$$

### The BJT

The BJT is the other type of transistor, it functionals similarly to the MOSFET, except that it a current-controlled switch, it also has different terminal names.

- The \kw{Base, B} of a BJT acts like the Gate of a MOSFET
- The \kw{Collector, C} of a BJT acts like the Drain of a MOSFET
- The \kw{Emitter, E} of a BJT acts like the Source of a MOSFET

The BJT also comes in two flavours (NPN, and PNP). The circuit symbols for each is shown below. Note that the terminal with the arrow is always the Emitter, and NPN can be distinguished by remebering it means 
that the arrow is "not-poiting inwards"

\begin{center}\vspace{2cm}\begin{circuitikz}
	\draw (0,0) node[npn](NMOS){NPN};
	\draw (5,0) node[pnp](PMOS){PNP};
	% terminal labels
	\draw (NMOS.B) node[label=left:Base]{};
	\draw (PMOS.B) node[label=left:Base]{};
	\draw (NMOS.E) node[label=below:Emitter]{};
	\draw (PMOS.E) node[label=above:Emitter]{};
	\draw (NMOS.C) node[label=above:Collector]{};
	\draw (PMOS.C) node[label=below:Collector]{};
\end{circuitikz}\end{center}

Also note that the base actually accepts a current this time, the base-current $i_B$ flows into the base for NPN, and out of the base for PNP BJTs, such that the below is always held true
$$
i_B + i_C = i_E
$$

### Operating Regions of a BJT

Like with MOSFETS, the BJT is also a non-linear device. The BJT is literally made up of two diodes, so the operating region depends on the biasing of the \kw{Emitter-Base Junction (EBJ)}
abd the \kw{Collector-Base Junction (CBJ)}. A short table is provided below

| Operating Region | CBJ Biasing | EBJ Biasing |
| --- | --- | --- |
| Cutoff | Reverse | Reverse |
| Active | Reverse | Forward |
| Reverse-Active | Forward | Reverse |
| Saturation | Active | Active |

Note that the Active region for BJT is the desired region for amplifiers, the saturation mode in BJTs is not similar to the saturation region for MOSFETs
Now we can take a look at the characteristics and conditions for each state above

| Operating Region | Condition (NPN) | Condition (PNP) | Current Flow |
| --- | --- | --- | --- |
| Cutoff | $v_E > v_B$ and $v_C > v_B$ | $v_B > v_E$ and $v_B > v_C$ | |
| Active | $v_E < v_B < v_C$ |  $v_E > v_B > v_C$ | $i_C = \beta i_B$ and $i_C = \frac{\beta}{1 + \beta} i_E$ |
| Reverse-Active | $v_E > v_B > v_C$ | $v_E < v_B < v_C$ | |
| Saturation | $v_B > v_E$ and $v_B > v_C$ | $v_E > v_B$ and $v_C > v_B$ ||

### Current Rules of a BJT

Since the base of a BJT permits current flow, often the voltage divider at the base is now actually a current divider, this is easy to deal with by replacing it with a thevenin equivalent
and contininuing the DC analysis. The current relation rules of a BJT in active mode is not easy to remember though, below is a short schematic representation of the equations

\begin{center} \begin{circuitikz}[american]
	\draw (0,0) node[npn](NMOS){};

	\draw (NMOS.B)++(-1,0) to[short, i=$i_B$] (NMOS.B);
	\draw (NMOS.E)++(0,-1) to[short, i_<=$(\beta + 1)i_B$] (NMOS.E);
	\draw (NMOS.C)++(0, 1) to[short, i=$\beta i_B$] (NMOS.C);
\end{circuitikz} \end{center}

\begin{equation}
i_E = i_B + i_C
\end{equation}

\begin{equation}
i_C = \beta i_B
\end{equation}

\begin{equation}
i_E = (\beta + 1) i_B
\end{equation}

