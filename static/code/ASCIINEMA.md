# `asciinema`

## Record

Record a session:

```sh
asciinema rec recording.cast
# exit to end recording
```

Record a session with multiple windows with `tmux`:

```sh
asciinema rec recording.cast
tmux
# enter commands for left session
# Ctrl + B, % (to split vertically)
# enter commands for right session
exit
exit
exit
```

## Edit

### Sanitization

**Remove username/path:**

```
sed -i 's/user@pc/shallow@dive/g' recording.cast
# example user@pc: niklas@laptop
sed -i 's#/path#/other/path#g' recording.cast
# example path: Documents/GitHubSSH/ShallowDiveBlog/static/code/computer_networks/tcp
```

### Remove unnecessary parts

This can be done by either deleting them or hiding them:

```
# start
{"version":3,"term":{"cols":100,"rows":36,"type":"xterm-256color","version":"Konsole 25.04.3","theme":{"fg":"#17a88b","bg":"#1e2229","palette":"#000000:#b21818:#18b218:#b26818:#1818b2:#b218b2:#18b2b2:#b2b2b2:#686868:#ff5454:#54ff54:#ffff54:#5454ff:#ff54ff:#54ffff:#ffffff"}},"timestamp":1755379023,"env":{"SHELL":"/bin/bash"}}
# from here
[0.036454, "o", "\u001b]0;niklas@niklas-ms7977:~/Documents/GitHubSSH/ShallowDiveBlog/static/code/computer_networks/tcp\u0007"]
[0.000087, "o", "\u001b[?2004h"]
[0.000006, "o", "\u001b[01;32m[niklas@niklas-ms7977\u001b[01;37m tcp\u001b[01;32m]$\u001b[00m "]
[0.404629, "o", "t"]
[0.704053, "o", "m"]
[0.241844, "o", "u"]
[0.130783, "o", "x"]
[0.385185, "o", "\r\n\u001b[?2004l\r"]
# to here
# ...
```

Make all of the time steps 0 until the actual second input (only hides the information, to delete remove the lines):

*Be careful with deleting since sometimes a line clears the page which needs to be considered, text lines should always be able to delete!*

```
{"version":3,"term":{"cols":100,"rows":36,"type":"xterm-256color","version":"Konsole 25.04.3","theme":{"fg":"#17a88b","bg":"#1e2229","palette":"#000000:#b21818:#18b218:#b26818:#1818b2:#b218b2:#18b2b2:#b2b2b2:#686868:#ff5454:#54ff54:#ffff54:#5454ff:#ff54ff:#54ffff:#ffffff"}},"timestamp":1755379023,"env":{"SHELL":"/bin/bash"}}
[0, "o", "\u001b]0;niklas@niklas-ms7977:~/Documents/GitHubSSH/ShallowDiveBlog/static/code/computer_networks/tcp\u0007"]
[0, "o", "\u001b[?2004h"]
[0, "o", "\u001b[01;32m[niklas@niklas-ms7977\u001b[01;37m tcp\u001b[01;32m]$\u001b[00m "]
[0, "o", "t"]
[0, "o", "m"]
[0, "o", "u"]
[0, "o", "x"]
[0, "o", "\r\n\u001b[?2004l\r"]
# ...
[0, "o", "p"]
# Stop here with setting them 0 since actual input is following
[0.080957, "o", "y"]
[0.178899, "o", "t"]
[0.086906, "o", "h"]
[0.135209, "o", "o"]
[0.171755, "o", "n"]
[0.085215, "o", " "]
[0.459906, "o", "s"]
[0.154872, "o", "e"]
[0.137121, "o", "r"]
[0.185088, "o", "v"]
[0.282824, "o", "er.py "]
```

For example at the end of a recording where e.g. the `tmux` session is closed by repeated `exit` inputs with no relevant content all of these lines can just be deleted (or set to 0):

```
# ...
[0.000007, "o", "Received: Hello, client!\r\nConnection open. Waiting...\u001b[24CConnection closed."]
[0.000012, "o", "\u001b[6;52H"]
[0.002333, "o", "\u001b[?25l\u001b[1;51H│\u001b[2;51H│\u001b[3;51H│\u001b[4;51H│\u001b[5;51H│\u001b[6;51H│\u001b[7;51H│\u001b[8;51H│\u001b[9;51H│\u001b[10;51H│\u001b[11;51H│\u001b[12;51H│\u001b[13;51H│\u001b[14;51H│\u001b[15;51H│\u001b[16;51H│\u001b[17;51H│\u001b[18;51H│\u001b[19;51H\u001b[32m│\u001b[20;51H│\u001b[21;51H│\u001b[22;51H│\u001b[23;51H│\u001b[24;51H│\u001b[25;51H│\u001b[26;51H│\u001b[27;51H│\u001b[28;51H│\u001b[29;51H│\u001b[30;51H│\u001b[31;51H│\u001b[32;51H│\u001b[33;51H│\u001b[34;51H│\u001b[35;51H│\u001b(B\u001b[m\u001b[?12l\u001b[?25h\u001b[6d\u001b[32m\u001b[1m[niklas@niklas-ms7977\u001b[37m tcp\u001b[32m]$\u001b(B\u001b[m "]
[0.997907, "o", "\rClosing connection.\u001b[60C"]
# delete all lines from here or set them all to 0
[0.003032, "o", "\u001b[?25l\u001b[1;51H│\u001b[2;51H│\u001b[3;51H│\u001b[4;51H│\u001b[5;51H│\u001b[6;51H│\u001b[7;51H│\u001b[8;51H│\u001b[9;51H│\u001b[10;51H│\u001b[11;51H│\u001b[12;51H│\u001b[13;51H│\u001b[14;51H│\u001b[15;51H│\u001b[16;51H│\u001b[17;51H│\u001b[18;51H│\u001b[19;51H\u001b[32m│\u001b[20;51H│\u001b[21;51H│\u001b[22;51H│\u001b[23;51H│\u001b[24;51H│\u001b[25;51H│\u001b[26;51H│\u001b[27;51H│\u001b[28;51H│\u001b[29;51H│\u001b[30;51H│\u001b[31;51H│\u001b[32;51H│\u001b[33;51H│\u001b[34;51H│\u001b[35;51H│\u001b(B\u001b[m\u001b[?12l\u001b[?25h\u001b[6;80H\r\n\u001b[32m\u001b[1m[niklas@niklas-ms7977\u001b[37m tcp\u001b[32m]$\u001b(B\u001b[m \u001b[6;80H"]
[0.926028, "o", "e"]
[0.20131, "o", "x"]
[0.123974, "o", "i"]
[0.115922, "o", "t"]
[0.167792, "o", "\u001b[7;52H"]
[0.000165, "o", "logout\u001b[8;52H"]
[0.001788, "o", "\u001b[?25l\u001b[32m\u001b[1m\u001b[H[niklas@niklas-ms7977\u001b[37m tcp\u001b[32m]$\u001b(B\u001b[m python server.py \u001b[K\r\nServer listening on 127.0.0.1:6000\u001b[K\r\nConnected by ('127.0.0.1', 54846)\u001b[K\r\nReceived: Hello, server!\u001b[K\r\nConnection open. Waiting...\u001b[K\r\nClosing connection.\u001b[K\u001b[32m\u001b[1m\r\n[niklas@niklas-ms7977\u001b[37m tcp\u001b[32m]$\u001b(B\u001b[m \u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\r\n\u001b[K\u001b[30m\u001b[42m\r\n[0] 0:bash*                                                  \"niklas@niklas-ms7977:\" 23:17 16-Aug-25\u001b(B\u001b[m\u001b[?12l\u001b[?25h\u001b[7;29H"]
[0.000056, "o", "\r\u001b[32m\u001b[1m[niklas@niklas-ms7977\u001b[37m tcp\u001b[32m]$\u001b(B\u001b[m \u001b[K"]
[0.243171, "o", "e"]
[0.201989, "o", "x"]
[0.093948, "o", "i"]
[0.165293, "o", "t"]
[0.14138, "o", "\r\n"]
[0.000173, "o", "logout\r\n"]
[0.001639, "o", "\u001b[1;36r\u001b(B\u001b[m\u001b[?1l\u001b>\u001b[H\u001b[2J\u001b[?12l\u001b[?25h\u001b[?1000l\u001b[?1002l\u001b[?1003l\u001b[?1006l\u001b[?1005l\u001b[?2004l\u001b[?7727l\u001b[?1004l\u001b[?1049l\u001b[23;0;0t"]
[0.000104, "o", "[exited]\r\n"]
[0.000304, "o", "\u001b]0;niklas@niklas-ms7977:~/Documents/GitHubSSH/ShallowDiveBlog/static/code/computer_networks/tcp\u0007"]
[0.000044, "o", "\u001b[?2004h\u001b[01;32m[niklas@niklas-ms7977\u001b[01;37m tcp\u001b[01;32m]$\u001b[00m "]
[0.660101, "o", "e"]
[0.22086, "o", "x"]
[0.090663, "o", "i"]
[0.230478, "o", "t"]
[0.44998, "o", "\r\n\u001b[?2004l\r"]
[0.000065, "o", "exit\r\n"]
# to here
[0.000545, "x", "0"]
```

```
[0.000007, "o", "Received: Hello, client!\r\nConnection open. Waiting...\u001b[24CConnection closed."]
[0.000012, "o", "\u001b[6;52H"]
[0.002333, "o", "\u001b[?25l\u001b[1;51H│\u001b[2;51H│\u001b[3;51H│\u001b[4;51H│\u001b[5;51H│\u001b[6;51H│\u001b[7;51H│\u001b[8;51H│\u001b[9;51H│\u001b[10;51H│\u001b[11;51H│\u001b[12;51H│\u001b[13;51H│\u001b[14;51H│\u001b[15;51H│\u001b[16;51H│\u001b[17;51H│\u001b[18;51H│\u001b[19;51H\u001b[32m│\u001b[20;51H│\u001b[21;51H│\u001b[22;51H│\u001b[23;51H│\u001b[24;51H│\u001b[25;51H│\u001b[26;51H│\u001b[27;51H│\u001b[28;51H│\u001b[29;51H│\u001b[30;51H│\u001b[31;51H│\u001b[32;51H│\u001b[33;51H│\u001b[34;51H│\u001b[35;51H│\u001b(B\u001b[m\u001b[?12l\u001b[?25h\u001b[6d\u001b[32m\u001b[1m[niklas@niklas-ms7977\u001b[37m tcp\u001b[32m]$\u001b(B\u001b[m "]
[1, "o", "\rClosing connection.\u001b[60C"]
[1, "x", "0"]
```

### Optimize keyboard inputs

Not every keystroke is sometimes important:

```
[3.119379, "o", "p"]
[0.080957, "o", "y"]
[0.178899, "o", "t"]
[0.086906, "o", "h"]
[0.135209, "o", "o"]
[0.171755, "o", "n"]
[0.085215, "o", " "]
[0.459906, "o", "s"]
[0.154872, "o", "e"]
[0.137121, "o", "r"]
[0.185088, "o", "v"]
[0.282824, "o", "er.py "]
[1.073071, "o", "\r\n"]
```

```
[0, "o", "python server.py"]
[1, "o", "\r\n"]
```

## Playback

```
asciinema play recording.cast
```
