# Power Amplifiers

## Introduction

### Power Amplifier?

When creating a multi-stage amplifier, we often want specific desireable characteristics for each stage that closely resemble the ideal amplifier.

- The **first stage** should have a VERY HIGH input impedance, so that we can properly recieve the signal
- The **intermediate stages** should have a VERY HIGH gain, so we can properly amplify the signal
- The **final stage** should have a very low output resistance so we can send the signal out without losing gain

This means that the last stage of amplifiers usually deals with extremely large signals, thus we must be careful when using the *small-signal model* during analysis of the last stage. 

However we still expect the signal to be *linearly amplified* and want to send the *maximum power* out to the load. The last stage of amplifiers are typically called \kw{power amplifiers} as they do exactly what we need!

### Power Amplifiers by Class

One approach in order to categorize power amps, is by \kw{class}. These classes represent the amount the output signal varies over one cycle of operation on the input signal. In this course we will go over the following classes of power amp.

- Class A
- Class B
- Class AB

Usually we take the input signal as one cycle of a sine wave, and see how the amplifier responds to it.

### Class A Amplifiers

Below is a plot of the current output of a typical class A amplifier, notice that the DC bias current is higher than the amplitude of the entire AC component. This means that the output signal fully tracks all 2$\pi$ radians of the input.

\begin{center} \begin{tikzpicture}

\begin{axis}[
	width = 0.7\textwidth,
	height = 0.3\textwidth,
	xlabel = $t$,
	ylabel = $i(t)$,
	grid = both,
	axis lines = middle,
	samples = 100,
	domain = 0:7,
	ymin = 0, ymax = 6,
	ytick = {0, 2, 3, 4},
	yticklabels = { $0$, $I_c - i_c$, $I_c$, $I_c + i_c$ }
	]

\addplot[purple, thick] {sin(deg(x)) + 3};
\end{axis}

\end{tikzpicture} \end{center}

This biasing also causes the power consumption of this amplifier to be quite high, thus these types of amps are not super efficient with power.

### Class B Amplifiers

In Class B Amplifiers the transistors are not biased, so they can only produce the positive swing of the input as during the negative part of the cycle the transistor would be in *cutoff* mode, A plot of this is shown below

\begin{center} \begin{tikzpicture}

\begin{axis}[
	width = 0.7\textwidth,
	height = 0.3\textwidth,
	xlabel = $t$,
	ylabel = $i(t)$,
	grid = both,
	axis lines = middle,
	samples = 100,
	domain = 0:6*pi,
	ymin = 0, ymax = 3,
	ytick = {0, 1},
	yticklabels = { $I_c$, $I_c + i_c$ }
	]

\addplot[purple, thick] {sin(deg(x))};
\end{axis}

\end{tikzpicture} \end{center}

This means to get the full range of input tracking, we would need to use 2 Class B amplifiers. Compared to class A, these tend to be more power efficient, but obviously it has more signal distortion since we cant track the full input signal

### Class AB Amplifiers

A class AB amplifier features some small biasing from the class B amplifier that allows us to track more than half the input signal, but here the biasing is smaller than the amplitude of the ac signal. A plot of this is shown below. To reproduce the entire input, we would need to use two class AB amplifiers.

\begin{center} \begin{tikzpicture}

\begin{axis}[
	width = 0.7\textwidth,
	height = 0.3\textwidth,
	xlabel = $t$,
	ylabel = $i(t)$,
	grid = both,
	axis lines = middle,
	samples = 100,
	domain = 0:6*pi,
	ymin = 0, ymax = 3,
	ytick = {0, 0.3,  1.3},
	yticklabels = { $0$, $I_c$, $I_c + i_c$ }
	]

\addplot[purple, thick] {sin(deg(x)) +0.3};
\end{axis}

\end{tikzpicture} \end{center}

The Class AB amplifier has a cleaner output than the class B due to the small DC biasing, and is also more efficient than a class A amp, since the biasing point is much lower. So its sort of in the middle of A and B.

## Current Mirrors

A \kw{current mirror} is a small block we can use to bias the most popular type of class A amplifier, which is an emitter follower (or common collector) topology. This is because of the very low output Resistance.

As discussed previously we need to bias this class A amplifier with some current source $I$. This is shown below.

\begin{center} \begin{circuitikz}[american]
	\draw (0,0) node[npn] (NPN) {$Q_1$};
	\draw (NPN.B) to[short] ++(-1,0) node[ocirc, label=left:$v_i$]{};
	\draw (NPN.C) to ++(0,1) node[vcc]{+Vcc};
	\draw (NPN.E) to[short, i=$i_E$] ++(0,-1) node[circ](LOAD){} to[isource, l=$I$] ++(0,-2) node[vee]{-Vcc};
	\draw (LOAD) to ++(2,0) to[resistor, l=$R_L$, i=$i_L$] ++(0,-2) node[ground]{}; 
\end{circuitikz} \end{center}

The current mirror essentially replaces our ideal current source from the above, with the following circuit.

\begin{center} \begin{circuitikz}[american]
	\draw (0,0) node[npn] (NPN) {$Q_1$};
	\draw (NPN.C) to[short, i<=$I$] ++(0,1);
	\draw (NPN.B) to ++(-1,0) node[circ](BIAS){};
	\draw (BIAS) to[resistor, l=$R$] ++(0,2) to ++(-1,0) node[ground]{};
	\draw (BIAS) to[diode, l=$Q_2$] ++(0,-2) node[vee]{-Vcc};
	\draw (NPN.E) to ++(0,-1) node[vee]{-Vcc};
\end{circuitikz} \end{center}
