---
title: Mathe (Graphen)
summary: Graphen in der Mathematik
date: 2025-10-07
tags:
  - Math
categories:
  - Math
draft: true
math: true
---

## Graphen

Ein Graph $G = (V, E)$ besteht aus *Vertices* $V$ (Knoten) und *Edges* $E$ (Kanten).

Die Knoten sind dabei eine Menge {{< mathinline >}}$V = \{x_1, \dots, x_n \}${{< /mathinline >}} und die Kanten sind eine Menge {{< mathinline >}}$E = \{(x_i, x_j) \mid x_i, x_j \in V \}${{< /mathinline >}} für **gerichtete Graphen** (also mit Pfeilen welche eine bestimmte Richtung haben) und {{< mathinline >}}$E = \big\{\{x_i, x_j\} \mid x_i, x_j \in V \big\}${{< /mathinline >}} für **ungerichtete Graphen** ohne Pfeile:

{{< figure src="../../../images/math_graphs/gerichteter_ungerichteter_graph.svg" alt="Gerichteter und Ungerichteter Graph Beispiel" width=90%" >}}

Knoten können dabei verschiedene Eigenschaften haben:

- **benachbart** wenn eine Kante 2 Knoten verbindet
- **schlingenfrei** falls jede Kante 2 verschiedene Konten verbindet
- **vollständig** falls jedes mögliche Knotenpaar durch eine Kante verbunden ist
- bei ungerichteten Graphen:
  - die Anzahl der Kanten die einen Konten $x$ enthalten nennt man **Grad** $d(x)$
- bei gerichteten Graphen:
  - die Anzahl der Kanten, die von einem Knoten $x$ ausgehen nennt man **Ausgangsgrad** $d^+(x)$
  - die Anzahl der Kanten, die in einem Knoten $x$ enden nennt man **Eingangsgrad** $d^-(x)$

{{< figure src="../../../images/math_graphs/grade_graphs.svg" alt="Grade in Graphen Beispiel" width=90%" >}}

{{< figure src="../../../images/math_graphs/properties_graphs.svg" alt="Weitere Eigenschaften in Graphen Beispiel" width=90%" >}}

### Multigraphen/Hypergraphen

Bei dieser Definition gibt es den Nachteil, dass es nicht möglich ist mehrere Kanten zwischen denselben 2 Konten zu definieren.

Dies braucht man z.B: für verschiedene Linien über denselben Gleisen in einem Eisenbahnnetz und könnte durch die Erweiterung durch eine zusätzliche Information wie Farbe/Linienname ergänzen (Kante: $(x_i, x_j, \text{Farbe})$).
Ein solcher Graph wird dann Multigraph genannt.

{{< figure src="../../../images/math_graphs/multigraph_example.svg" alt="Multigraph Beispiel" width=80%" >}}

Jeder Multigraph kann in einen Graph transformiert werden durch das Einführen von neuen Knoten.

Es gibt auch Graphen bei welcher eine Kante mehr als 2 Konten verbindet wie z.B. für Studenten (Knoten) welche Module (Kanten) belegen.
Ein solcher Graph wird dann Hypergraph genannt.

{{< figure src="../../../images/math_graphs/hypergraph_example.svg" alt="Hypergraph Beispiel" width=60%" >}}

### Schlussfolgerungen

- Falls die Anzahl aller Grade der doppelten Kantenzahl entspricht, ist der Graph schlingenfrei und ungerichtet: $\sum^n_{i=1}d(x_i)=2k$

  - Im Falle, dass der Graph Schlingen enthält kann man diese Abziehen: ${\color{grey}\sum^n_{i=1}d(x_i)}={\color{grey}2k}-s$

  {{< figure src="../../../images/math_graphs/schlussfolgerung_1.svg" alt="Multigraph Beispiel" width=80%" >}}

- In jedem gerichteten Graphen ist die Summe aller Ausgangsgrade gleich der Summe aller Eingangsgrade, und beide sind gleich der Anzahl der gerichteten Kanten: $\sum^n_{i=1}d^+(x_i)=\sum^n_{i=1}d^-(x_i)=k$

  {{< figure src="../../../images/math_graphs/schlussfolgerung_2.svg" alt="Multigraph Beispiel" width=80%" >}}
  

{{< note >}}
Frage nach inwieweit dies nützlich ist, da es ja auch für ungerichtete Graphen gilt, wenn man die Kante doppelt zählt?
{{< /note >}}

## Wege

Ein Weg in einem Graph $G$ ist eine Folge von Knoten $(x_0,  \dots, x_k)$, falls die Kantenmenge $E$ die Kanten zwischen den Konten enthält (e.g. für den Weg $(a, b, c)$ muss die Kantenmenge $E$ $(a,b)$ und $(b,c)$ enthalten in einem gerichteten Graph $G=(V,E)$).

Die Länge des Weges ergibt sich aus der Anzahl der Kanten aus welchen dieser besteht.

Falls $x_0 = x_k$ heißt der Weg **geschlossen**, sonst ist er **offen**.

Von einem **Kreis** spricht man wenn es ein geschlossener Weg ist in dem keine Kante mehrfach vorkommt.

{{< figure src="../../../images/math_graphs/weg.svg" alt="Weg Beispiel" width=80%" >}}

Wenn ein Graph keine Kreise enthält nennt man diesen **kreisfrei**.

### Abstand

Der **Abstand** $d(x_1, x_2)$ zwischen 2 Knoten ($x_1$ und $x_2$) ist die Länge des kleinstmöglichen Weges zwischen diesen:

{{< figure src="../../../images/math_graphs/abstand.svg" alt="Hypergraph Beispiel" width=60%" >}}

Alle Knoten welche mit dem Abstand $d = 1$ von einem Konten entfernt sind nennt man **Nachbarschaft**:

{{< figure src="../../../images/math_graphs/nachbarschaft.svg" alt="Hypergraph Beispiel" width=60%" >}}

### Zusammenhängend

Bei ungerichteten Graphen spricht man von **zusammenhängen** wenn für jeden Knoten ein Weg existiert zu jedem anderen Knoten.

Bei gerichteten Graphen spricht man wenn dasselbe gilt von **stark zusammenhängend**, wenn durch das weglassen der Richtung ein zusammenhängender Graph entsteht spricht man von **schwach zusammenhängend**:

{{< figure src="../../../images/math_graphs/zusammenhängend.svg" alt="Weg Beispiel" width=80%" >}}

Falls einzelne Teile des Graphs zusammenhängen nennt man diese Zusammenhangskomponenten.
Diese kann man mithilfe von Äquivalenzklassen ausdrücken:

{{< mathblock >}}
$$
\begin{aligned}
R = \{(x, y) \mid x, y \in V, \exists \text{ Weg von }x\text{  nach }y\}
\end{aligned}
$$
{{< /mathblock >}}

TODO Beispiel

Ein Knoten $x \in V$ wird als **trennend** bezeichnet, wenn ein Graph nach dem Herausnehmen mehr Zusammenhangskomponenten aufweist:

{{< figure src="../../../images/math_graphs/trennend.svg" alt="Weg Beispiel" width=80%" >}}

## Darstellungen von Graphen

### Adjazensmatrizen

Kanten kann man mithilfe von einer $n \times n$ Adjazensmatrix über $n$ Knoten dargestellt werden:

{{< mathblock >}}
$$
\begin{bmatrix}
0 & 1 & 0 \\
0 & 0 & 1 \\
1 & 0 & 0
\end{bmatrix}
\Rightarrow
\begin{array}{c|ccc}
      & x_1 & x_2 & x_3 \\ \hline
x_1 & 0 & 1 & 0 \\
x_2 & 0 & 0 & 1 \\
x_3 & 1 & 0 & 0
\end{array}
$$
{{< /mathblock >}}

Diese Matrix bedeutet wir haben die Knoten $x_1, x_2, x_3$ und haben eine Kante von $x_1$ zu $x_2$, eine von $x_2$ zu $x_3$ und von $x_3$ zu $x_1$:

TODO Bild

{{< details summary="Beispiel" open=true >}}
Here’s the content you can expand/collapse.
{{< /details >}}


## Help

{{< mathblock >}}
$$
\begin{aligned}
f(x) &= x^2 + 2x + 1 \\
     &= (x+1)^2
\end{aligned}
$$
{{< /mathblock >}}
{{< mathblock >}}
$$
\begin{align}
f(x) &= x^2 + 2x + 1 \\
     &= (x+1)^2
\end{align}
$$
{{< /mathblock >}}
