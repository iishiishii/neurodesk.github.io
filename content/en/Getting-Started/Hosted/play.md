---
title: "Play"
linkTitle: "Play"
weight: 1
aliases:
- /docs/neurodesktop/getting-started/play
- /docs/getting-started/neurodesktop/play
- /docs/getting-started/hosted/play

description: >
   Neurodesk Play is a publicly available service for accessing Neurodesk without any setup
---

Neurodesk Play provides instant access to our neuroimaging analysis environment directly through your web browser. This service allows you to:

- Start using Neurodesk immediately without any installation.
- Access a wide range of pre-installed neuroimaging tools.
- Try out the platform before setting up a local installation.
- Collaborate with colleagues using a consistent environment.

> **Note:** Neurodesk Play is free but comes with resource limits. For more intensive workloads, consider [installing Neurodesk App](/getting-started/app/) or using one of our [other hosting options](/docs/getting-started/hosted/).

## Launch Neurodesk Play
The tool below automatically detects the fastest server for your location. Click the **Recommended** card to start.

<!-- Play Server latency widget -->
<div id="server-latency-widget" style="margin: 20px 0; padding: 25px; border: 1px solid #e1e4e8; border-radius: 8px; background: #fafbfc; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; text-align: center;">

<style>
    .ping-container { display: flex; justify-content: center; gap: 15px; flex-wrap: wrap; margin-bottom: 20px; }
    
    .ping-card {
        background: white; padding: 15px; border-radius: 8px; 
        box-shadow: 0 1px 3px rgba(0,0,0,0.12); width: 180px;
        border: 2px solid transparent; transition: all 0.2s ease-in-out;
        text-decoration: none !important; color: inherit !important; display: block;
        cursor: pointer; position: relative; text-align: center;
    }
    
    .ping-card:hover { transform: translateY(-2px); box-shadow: 0 8px 16px rgba(0,0,0,0.1); }
    .ping-winner { border-color: #28a745; background-color: #f0fff4; transform: scale(1.05); }
    
    .ping-name { font-weight: 700; display: block; margin-bottom: 5px; font-size: 1.1em; color: #0366d6; }
    .ping-time { font-size: 1.4em; font-weight: 700; margin: 8px 0; color: #24292e; }
    .ping-req { font-size: 0.75em; color: #586069; background: #f6f8fa; padding: 2px 8px; border-radius: 10px; display: inline-block; border: 1px solid #e1e4e8;}
    .ping-status { font-size: 0.85em; color: #586069; margin-top: 5px; display: block;}
    
    .ping-btn {
        padding: 8px 16px; background-color: #fff; color: #24292e; 
        border: 1px solid #d1d5da; border-radius: 6px; cursor: pointer; font-size: 0.9em; margin-top: 10px; transition: background 0.2s;
    }
    .ping-btn:hover { background-color: #f3f4f6; }
</style>

<div class="ping-container">
    <!-- US Server --><a href="https://play-america.neurodesk.org" target="_blank" id="card-1" class="ping-card">
        <span class="ping-name">🇺🇸 US</span>
        <div class="ping-req">Login: GitHub</div>
        <div id="ping-1" class="ping-time">-- ms</div>
        <span id="status-1" class="ping-status">Waiting...</span>
    </a><!-- EU Server --><a href="https://play-europe.neurodesk.org" target="_blank" id="card-2" class="ping-card">
        <span class="ping-name">🇪🇺 Europe</span>
        <div class="ping-req">Login: GitHub</div>
        <div id="ping-2" class="ping-time">-- ms</div>
        <span id="status-2" class="ping-status">Waiting...</span>
    </a><!-- AU Server --><a href="https://play.neurodesk.cloud.edu.au" target="_blank" id="card-3" class="ping-card">
        <span class="ping-name">🇦🇺 Australia</span>
        <div class="ping-req">Login: AAF</div>
        <div id="ping-3" class="ping-time">-- ms</div>
        <span id="status-3" class="ping-status">Waiting...</span>
    </a>
</div>

<button id="ping-btn" class="ping-btn" onclick="runPingTest()">Re-test Latency</button>

<script>
(function() {
const servers = [
{ id: 1, url: "https://play-america.neurodesk.org" },
{ id: 2, url: "https://play-europe.neurodesk.org" },
{ id: 3, url: "https://play.neurodesk.cloud.edu.au" }
];

window.runPingTest = async function() {
const btn = document.getElementById('ping-btn');
if(btn) { btn.disabled = true; btn.innerText = "Testing..."; }

servers.forEach(s => {
document.getElementById(`card-${s.id}`).classList.remove('ping-winner');
document.getElementById(`ping-${s.id}`).innerText = "-- ms";
document.getElementById(`status-${s.id}`).innerText = "Pinging...";
});

const check = async (url) => {
const start = performance.now();
try {
await fetch(url, { mode: 'no-cors', cache: 'no-cache', method: 'HEAD' });
return Math.round(performance.now() - start);
} catch (e) { return -1; }
};

const results = await Promise.all(servers.map(s => check(s.url)));
const finalData = servers.map((s, index) => ({ ...s, time: results[index] }));

finalData.forEach(item => {
const el = document.getElementById(`ping-${item.id}`);
const status = document.getElementById(`status-${item.id}`);
if (item.time === -1) {
el.innerText = "Error"; el.style.color = "#d73a49"; status.innerText = "Unreachable";
} else {
el.innerText = item.time + " ms"; el.style.color = "#24292e"; status.innerText = "Online";
}
});

const valid = finalData.filter(d => d.time !== -1);
if (valid.length > 0) {
valid.sort((a, b) => a.time - b.time);
const winner = valid[0];
document.getElementById(`card-${winner.id}`).classList.add('ping-winner');
const winStatus = document.getElementById(`status-${winner.id}`);
winStatus.innerText = "Recommended";
winStatus.style.fontWeight = "bold"; winStatus.style.color = "#28a745";
}
if(btn) { btn.disabled = false; btn.innerText = "Re-test Latency"; }
};
runPingTest();
})();
</script>
</div>
<!-- Play Server latency widget -->

## Usage Acknowledgments

When using these services for research, please include the appropriate acknowledgment:

**🇺🇸 US (Jetstream2 / NSF)**
> "This research was supported by Jetstream2 (NSF award #2005506), which is supported by the National Science Foundation. Jetstream2 is a cloud computing resource managed by the Indiana University Pervasive Technology Institute and part of the ACCESS project."

**🇪🇺 Europe (EGI / CESNET-MCC)**
> "Enabled through services and resources provided by the EGI Federation with the dedicated support of CESNET-MCC. Computational resources were provided by the e-INFRA CZ project (ID:90254), supported by the Ministry of Education, Youth and Sports of the Czech Republic."

**🇦🇺 Australia (ARDC / Nectar)**
> "This research was supported by use of the Nectar Research Cloud, a collaborative Australian research platform supported by the NCRIS-funded Australian Research Data Commons (ARDC)."


## Data Transfer
We provide several methods to transfer your files in and out of Neurodesk Play, including drag-and-drop and cloud storage integration. 
[View Data Transfer Documentation &rarr;](/docs/neurodesktop/storage)

## Shared directories for courses and workshops

Neurodesk Play can provide shared directories for educational use. These directories are mounted inside Play sessions under `/data/groups/<group-name>` or `/data/teaching/<educator-github-username>` and can be configured for different teaching and project needs.

- **Educator-managed course material:** educators can write to a directory under `/data/teaching/<educator-github-username>`, while all other users have read-only access.
- **Project groups:** a defined group of users can share a directory where every group member has read+write access under `/data/groups/<group-name>`.
- **Teaching teams:** multiple educators can have write access to a shared directory under `/data/groups/<group-name>`, while everyone else has read-only access.

This is useful for distributing workshop datasets, notebooks, examples, or course material without asking every participant to copy files into their own home directory. It also makes it very easy to provide the solutions of a previous session to all users to learners can catchup to the rest of the class.

If you need such a setup, please reach out to mail.neurodesk@gmail.com with information on when your course runs and how much storage you need.

## SSH connection
It is possible to connect to Play instances using SSH, including from VS Code Remote SSH. Neurodesk Play uses [`jupyter-sshd-proxy`](https://pypi.org/project/jupyter-sshd-proxy/) to proxy SSH over the authenticated JupyterHub connection.

### 1. Install `websocat` on your local computer

The SSH client connects through a WebSocket proxy, so `websocat` must be available on the computer where you run `ssh`.

On macOS:

```bash
brew install websocat
```

For Linux and Windows, install `websocat` from your package manager or download a binary from the [websocat releases](https://github.com/vi/websocat/releases).

### 2. Start your Neurodesk Play session

Launch one of the Play servers above and wait until JupyterLab has started. Keep this browser session running while you use SSH.

You will need three values:

- **Play domain:** for example `play-america.neurodesk.org`, `play-europe.neurodesk.org`, or `play.neurodesk.cloud.edu.au`.
- **JupyterHub username:** copy this from the browser URL. In a URL like `https://play-america.neurodesk.org/user/myname/lab`, the username is `myname`. If the URL contains encoded characters such as `%40`, use the URL value exactly as shown.

### 3. Create a JupyterHub token

In JupyterLab, open **File > Hub Control Panel**, then select **Token** and create a new token. 

Treat this token like a password to your play instance. Set an expiry date for best practice and not the expiry date in your calendar.

### 4. Add your SSH public key inside Play

Open a terminal in JupyterLab and add the public key that matches the private key on your local computer. If your public keys are available from GitHub, you can use:

```bash
mkdir -p ~/.ssh
wget https://github.com/<YOUR-GITHUB-USERNAME>.keys -O ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

Replace `<YOUR-GITHUB-USERNAME>` with your GitHub username.

### 5. Configure SSH on your local computer

Add an entry like this to `~/.ssh/config` on your local computer:

```sshconfig
Host neurodesk-play
    HostName <PLAY-DOMAIN>
    User jovyan
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
    ProxyCommand websocat --binary -H="Authorization: token <JUPYTERHUB-TOKEN>" asyncstdio: wss://%h/user/<JUPYTERHUB-USERNAME>/sshd/
```

Replace:

- `<PLAY-DOMAIN>` with the server you are using, for example `play-america.neurodesk.org`.
- `<JUPYTERHUB-TOKEN>` with the token you created.
- `<JUPYTERHUB-USERNAME>` with the username from your JupyterHub URL.
- `~/.ssh/id_ed25519` with the private key that matches the public key you added to `authorized_keys`.

### 6. Connect

From your local terminal:

```bash
ssh neurodesk-play
```

You can use the same SSH host in VS Code Remote SSH by connecting to `neurodesk-play`.

You can also copy files with `scp` or `sftp`, for example:

```bash
scp local-file.txt neurodesk-play:~/
sftp neurodesk-play
```

