---
title: Neurodesk
linktitle: Neurodesk
type: landing
---

<link rel="stylesheet" href="/css/landing-custom.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<section class="row td-box -bg-secondary justify-content-left h-auto col-big-desktop">
<div class="container">
    <div class="row align-items-center">
        <div class="col-md-8 order-md-1">
            <h1 class="hero-heading mt-0 pb-2">Reproduce Your Neuroimaging Analysis Anywhere</h1>
            <p class="lead">Stop wrestling with dependencies, version conflicts, and platform incompatibilities.<br>Neurodesk gives you consistent, reproducible neuroimaging tools across any system.</p>
            <div class="hero-values-grid mt-4 mb-4">
                <div class="hero-value-card">
                    <div class="hero-icon">
                        <i class="fas fa-desktop"></i>
                    </div>
                    <div class="hero-value-content">
                        <strong>One environment, any system</strong>
                        <p class="small mb-0">Run neuroimaging tools consistently across operating systems</p>
                    </div>
                </div>
                <div class="hero-value-card">
                    <div class="hero-icon">
                        <i class="fas fa-code"></i>
                    </div>
                    <div class="hero-value-content">
                        <strong>GUI or notebooks</strong>
                        <p class="small mb-0">Use a virtual desktop or Jupyter notebooks for reproducible workflows</p>
                    </div>
                </div>
                <div class="hero-value-card">
                    <div class="hero-icon">
                        <i class="fas fa-cloud-upload-alt"></i>
                    </div>
                    <div class="hero-value-content">
                        <strong>Local to cloud</strong>
                        <p class="small mb-0">Deploy locally, on HPC, or in the cloud without installation overhead</p>
                    </div>
                </div>
            </div>
            <div class="social-proof-stats mt-4 mb-4">
                <div class="stat-item">
                    <strong class="stat-number">100+</strong>
                    <span class="stat-label">Neuroimaging Tools</span>
                </div>
                <div class="stat-item">
                    <strong class="stat-number">Open Source</strong>
                    <span class="stat-label">Fully Transparent</span>
                </div>
                <div class="stat-item">
                    <strong class="stat-number">Independently Evaluated</strong>
                    <span class="stat-label"><a href="https://direct.mit.edu/imag/article/doi/10.1162/IMAG.a.79/131499" target="_blank">Accessibility & Usability Study published in MIT</a></span>
                </div>
            </div>
        </div>
        <div class="col-md-4 order-md-2 text-center">
            <img src="{{< relurl "/static/favicons/neurodesk-logo.svg" >}}" 
                 class="neurodesk-hero-logo" 
                 alt="Neurodesk logo - reproducible neuroimaging platform" />
        </div>
    </div>
</div>
</section>

<section class="row -bg-white justify-content-left h-auto col-big-desktop">
<div class="container py-3" style="padding-top: 1.5rem !important; padding-bottom: 1.5rem !important;">
    <div class="row justify-content-center">
        <div class="col-12 col-lg-8">
            <div class="row g-3">
                <div class="col-12 col-sm-6">
                    <a class="btn btn-lg btn-success w-100 p-3 shadow-lg" href="{{< relurl "/getting-started/hosted/play/" >}}" style="background-color: #9EC672; border-color: #9EC672; color: #1a1a1a;">
                        <i class="fas fa-rocket"></i> Try Neurodesk Now
                        <small class="d-block mt-1" style="font-size: 0.75rem; opacity: 0.8;">No installation required</small>
                    </a>
                </div>
                <div class="col-12 col-sm-6">
                    <a class="btn btn-lg btn-outline-dark w-100 p-3" href="{{< relurl "/getting-started/local/neurodeskapp/" >}}" style="border-width: 2px;">
                        <i class="fas fa-download"></i> Install Locally
                    </a>
                </div>
                <div class="col-12">
                    <div class="text-center mt-2 mb-0">
                        <a href="{{< relurl "/overview/faq/#what-is-neurodesk" >}}" class="text-dark" style="text-decoration: none; font-weight: 500;">Learn more about Neurodesk</a>
                        <span class="mx-2" style="color: #666;">·</span>
                        <a href="https://neurodesk.org/edu" class="text-dark" style="text-decoration: none; font-weight: 500;">See examples</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</section>

<section class="container-fluid">
<div class="container-fluid py-2" style="padding-top: 1.5rem !important; padding-bottom: 1.5rem !important; background-color: #f8f9fa;">
    <div class="row justify-content-center">
        <div class="col-12 col-lg-10 text-center">
            <h2 class="mb-3" style="color: #1a1a1a;">See Neurodesk in Action</h2>
            <p class="lead mb-4" style="color: #495057;">From data to analysis to visualization—all in one reproducible environment</p>
            <div class="position-relative video-container" style="max-width: 1200px; margin: 0 auto;">
                <div style="padding-top: 56.25%; position: relative;">
                    <img src="{{< relurl "/static/favicons/neurodesk.jpeg" >}}"
                        class="w-100 h-100 position-absolute top-0 start-0 object-fit-contain"
                        style="z-index: 1;"
                        alt="Neurodesk interface showing virtual desktop with neuroimaging tools">
                    <video class="w-100 h-100 position-absolute top-0 start-0 object-fit-contain"
                        style="z-index: 2;"
                        autoplay muted loop playsinline
                        onloadstart="this.previousElementSibling.style.display='none';">
                        <source src="{{< relurl "/static/favicons/neurodesk.webm" >}}" type="video/webm">
                        <source src="{{< relurl "/static/favicons/neurodesk.mp4" >}}" type="video/mp4">
                        Your browser does not support the video tag.
                    </video>
                </div>
            </div>
        </div>
    </div>
</div>
</section>

<section
  id="startup"
  class="row -bg-light justify-content-left h-auto col-big-desktop"
	style="
		background-image: url('{{< relurl "/static/favicons/background-bottom.svg" >}}');
    background-repeat: no-repeat;
    background-position: bottom center;
    background-size: 100% auto;">
	<div class="td-box">
		<h2>Neurodesk Components</h2>
		<p class="lead mt-2">Flexible tools that work together or independently.<br />Neurodesk makes it easy for beginners and experts to use neuroimaging tools for desktop, HPC, web, and cloud.</p>
	</div>
	<div class="component-start container-fluid py-3">
		<div class="row">
			<div class="col-12 col-xl-11 component-col">
				<div class="row justify-content-center">
					<div class="col-10 col-md-4 col-lg-4 mb-4">
						<div class="component-card shadow-sm desktop">
							<a class="component-click-btn d-flex flex-column" href="{{< relurl "/getting-started/neurodesktop/" >}}">
								<div class="card-body">
										<i class="fa fa-window-maximize"></i>
									<h4 class="mt-2">Neurodesktop</h4>
									<p class="card-summary">Complete virtual desktop environment with GUI applications, ready to use in your browser or locally.</p>
									<ul class="feature-list text-start small">
										<li>100+ pre-installed neuroimaging tools</li>
										<li>Full desktop experience (XFCE)</li>
										<li>No local installation required</li>
                        			</ul>
								</div>
								<div class="image-wrapper mt-2">
									<img src="{{< relurl "/static/favicons/neurodesktop.png" >}}" alt="Neurodesktop" class="img-fluid shadow-sm" />
								</div>
							</a>
						</div>
					</div>
					<div class="col-10 col-md-4 col-lg-4 mb-4">
						<div class="component-card shadow-sm containers">
							<a class="component-click-btn d-flex flex-column" href="{{< relurl "/getting-started/neurocontainers/" >}}">
								<div class="card-body">
									<i class="fas fa-layer-group"></i>
									<h4>Neurocontainers</h4>
									<p class="card-summary">Individual containerized tools you can use in your own pipelines and workflows.</p>
									<ul class="feature-list text-start small">
										<li>Transparent, version-controlled builds</li>
										<li>Use via Docker or Singularity</li>
										<li>Perfect for HPC and cloud</li>
									</ul>
								</div>
								<div class="image-wrapper mt-auto">
									<img src="{{< relurl "/static/favicons/neurocontainer.png" >}}" alt="neurocontainer" class="img-fluid" />
								</div>
							</a>
						</div>
					</div>
					<div class="col-10 col-md-4 col-lg-4 mb-4">
						<div class="component-card shadow-sm command">
							<a class="component-click-btn d-flex flex-column" href="{{< relurl "/getting-started/neurocommand/" >}}">
								<div class="card-body">
									<i class="fas fa-terminal"></i>
									<h4>Neurocommand</h4>
									<p class="card-summary">Command-line tool manager that fetches and runs containers seamlessly.</p>
									<ul class="feature-list text-start small">
										<li>Simple module-based interface</li>
										<li>Integrates with existing workflows</li>
										<li>Works on any Linux system</li>
									</ul>
								</div>
								<div class="image-wrapper mt-auto">
									<img class="neurocommand img-fluid" src="{{< relurl "/static/favicons/neurocommand.png" >}}"
										alt="Neurocommand" />
									<div class="fake">
										<div class=fakeMenu>
											<div class="fakeButtons fakeClose"></div>
											<div class="fakeButtons fakeMinimize"></div>
											<div class="fakeButtons fakeZoom"></div>
										</div>
										<div class="fakeScreen">
											<span class="typewriter type" style="--n:53">$ pip3 install -r
												neurodesk/requirements.txt --user</br />
												$ bash build.sh --cli</br />
												$ bash containers.sh</br />
												$ module use $PWD/local/containers/modules
											</span>
										</div>
									</div>
								</div>
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>

<section class="row -bg-secondary justify-content-left h-auto col-big-desktop">
	<div class="container-fluid community-start">
		<div class="row">
			<div class="col-10 col-sm-9 col-md-10 col-lg-3 col-xl-2 community-title">
			<h2>Community</h2>
            <h3>Neurodesk is a community project.</h3>
            <p class="lead mt-2">Our active community provides transparency and inclusion. We encourage you to engage and contribute.</p>
			</div>
			<div class="col-11 col-sm-11 col-md-10 col-lg-7 col-xl-8 community-col">
				<div class="row community">
					<div class="col-6 col-md-5 col-lg-6 col-xl-3">
						<div class="card community-card">
							<a href="{{< relurl "/overview/faq/#what-is-neurodesk" >}}">
								<div class="card-body">
										<i class=" fas fa-question-circle"></i>
									<h4>FAQ</h4>
									<p class="card-summary">Frequently Asked Questions</p>
								</div>
							</a>
						</div>
					</div>
					<div class="col-6 col-md-5 col-lg-6 col-xl-3">
						<div class="card community-card">
							<a target="_blank" href="https://github.com/orgs/neurodesk/discussions">
								<div class="card-body">
									<i class="fa fa-envelope"></i>
									<h4>Discussions</h4>
									<p class="card-summary">Ask questions, suggest new features or raise any issues you have (Github account required)</p>
								</div>
							</a>
						</div>
					</div>
					<div class="col-6 col-md-5 col-lg-6 col-xl-3">
						<div class="card community-card">
							<a href="{{< relurl "/developers/contributors" >}}">
								<div class="card-body">
									<i class="fa fa-users"></i>
									<h4>Contributors</h4>
									<p class="card-summary">Contributors</p>
								</div>
							</a>
						</div>
					</div>
					<div class="col-6 col-md-5 col-lg-6 col-xl-3">
						<div class="card community-card">
							<a href="{{< relurl "/overview/contribute" >}}">
								<div class="card-body">
									<i class="fa fa-code"></i>
									<h4>Contribution Guide</h4>
									<p class="card-summary">Learn how you can contribute to Neurodesk code and
										documentation</p>
								</div>
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
<section class="row td-box -bg-white justify-content-left h-auto col-big-desktop">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-12 col-lg-8 text-center">
            <h2 class="mb-3">Ready to Make Your Research Reproducible?</h2>
            <p class="lead mb-4">Join researchers worldwide using Neurodesk for transparent, reproducible neuroimaging.</p>
            <div class="d-flex flex-column flex-sm-row gap-3 justify-content-center">
                <a class="btn btn-lg btn-primary px-5" href="{{< relurl "/getting-started/hosted" >}}">
                    Get Started Now
                </a>
                <a class="btn btn-lg btn-outline-primary px-5" href="{{< relurl "/overview/faq/#what-is-neurodesk" >}}">
                    Learn More
                </a>
            </div>
        </div>
    </div>
</div>
</section>