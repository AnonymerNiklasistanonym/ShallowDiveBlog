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

{{< figure src="../../../images/math_graphs/multigraph_example.svg" alt="Hypergraph Beispiell" width=60%" >}}

Es gibt auch Graphen bei welcher eine Kante mehr als 2 Konten verbindet wie z.B. für Studenten (Knoten) welche Module (Kanten) belegen.
Ein solcher Graph wird dann Hypergraph genannt.

{{< figure src="../../../images/math_graphs/hypergraph_example.svg" alt="Hypergraph Beispiell" width=60%" >}}

## Help

{{< mathblock >}}$$
\begin{aligned}
f(x) &= x^2 + 2x + 1 \\
     &= (x+1)^2
\end{aligned}
$${{< /mathblock >}}

{{< mathblock >}}$$
\begin{align}
f(x) &= x^2 + 2x + 1 \\
     &= (x+1)^2
\end{align}
$${{< /mathblock >}}
