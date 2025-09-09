# Biomedical Modeling

## Types of System Models

There are a few types of models, ther exist \kw{black-box models} which contain a transfer function relating inputs to outputs.
There are also \kw{structural/parametric models} these models are dervied from physical laws, applied to known antomy or physiiological processes,
these models often rely on \kw{physical system analogies}. More often than not the latter is preferred

## Transfer Functions

Over this course several notations will be used, these also represent the different ways to represent transfer fucntions

- Time Domain: $y(t) = h(t) \text{conv} x(t)$
- Frequency Domain: $Y(\omega) = H(\omega) \cdot X(\omega)$ 
- Complex Frequency Domain: $X(s) = H(s) \cdot X(s)$

We will also consider the functions $h(t)$, $H(\omega)$, and $H(s)$ to be the impulse response of a system.

Recall the following relationships, these are only applicable for \kw{linear time-invariant systems}:

$$
H(\omega) = \text{FT}\left[ h(t) \right] = H(s) |_{s=j\omega}
$$
$$
H(s) = \text{LT}\left[ h(t) \right]
$$

## Lumped Parameter Models

A \kw{lumped-parameter model} is a network of 1-D connections among elements representing
import physical properties of a system
The elements are treated as *spatially compact*, so spatial veriation of parameters is neglected
This leads to systems yielding Ordinary Differentialy Equations (ODEs).

| Type of System | "Effort" | "Flow" |
| --- | --- | --- |
| Electrical | Voltage ($v$) | Current ($i$) |
| Solid Mechanics | Net Force ($F$) | Velocity ($v$) |
| Fluid Mechanics | Pressure ($P$) | Flow Rate ($Q$) |
| Chemical Diffusion | Conecntration ($\phi$) | Mass flux ($Q$) |

These components of lumped-parameter models can be combined into a circuit 
either in series or parallel, analogies between different types of systems are established
by connecting elements such that the *flow* quantity behaves identically in both systems.

Going forward the generalized effort variable will be denoted as $\effort$, and the flow variable will be denoted as $\flow$

## Resistor Equivalents

## Capactior Equivalents

## Inductor Equivalents

## Compartmental Models