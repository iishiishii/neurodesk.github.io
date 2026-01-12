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

> **Note:** Neurodesk Play is free but comes with resource limits. For more intensive workloads, consider [installing Neurodesk locally](/docs/getting-started/local/) or using one of our [other hosting options](/docs/getting-started/hosted/).

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

## Data Transfer
We provide several methods to transfer your files in and out of Neurodesk Play, including drag-and-drop and cloud storage integration. 
[View Data Transfer Documentation &rarr;](/docs/neurodesktop/storage)

## Usage Acknowledgments

When using these services for research, please include the appropriate acknowledgment:

**🇺🇸 US (Jetstream2 / NSF)**
> "This research was supported by Jetstream2 (NSF award #2005506), which is supported by the National Science Foundation. Jetstream2 is a cloud computing resource managed by the Indiana University Pervasive Technology Institute and part of the ACCESS project."

**🇪🇺 Europe (EGI / CESNET-MCC)**
> "Enabled through services and resources provided by the EGI Federation with the dedicated support of CESNET-MCC. Computational resources were provided by the e-INFRA CZ project (ID:90254), supported by the Ministry of Education, Youth and Sports of the Czech Republic."

**🇦🇺 Australia (ARDC / Nectar)**
> "This research was supported by use of the Nectar Research Cloud, a collaborative Australian research platform supported by the NCRIS-funded Australian Research Data Commons (ARDC)."

