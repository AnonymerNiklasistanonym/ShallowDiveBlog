# Computer Networks

## Wireshark

Start `wireshark` with `sudo` to capture local interfaces:

```sh
sudo pacman -S wireshark
sudo wireshark
```

Select local interface (should display an indicator that network traffic is being routed through it).

Filter protocols:

- TCP traffic: `tcp`

## PlantUML

```sh
sudo pacman -S plantuml
```

Convert `.puml` file to `.svg` file:

```sh
plantuml -tsvg file.puml
```

### Mermaid.js

```sh
sudo pacman -S mermaid-cli
```

Convert `.mmd` file to `.svg` file:

```sh
mmdc -i file.mmd -o file.svg
```

### Graphviz

```sh
sudo pacman -S graphviz
```

Convert `.dot` file to `.svg` file:

```sh
dot -Tsvg file.dot -o file.svg
```
