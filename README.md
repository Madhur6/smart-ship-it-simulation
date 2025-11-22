<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🚢 Smart Cruise Vessel IT Simulation - Enterprise Infrastructure Portfolio</title>
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --ocean-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --sunset-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            --tech-gradient: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            --dark-gradient: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            --glass-bg: rgba(255, 255, 255, 0.25);
            --glass-border: rgba(255, 255, 255, 0.18);
            --text-primary: #2c3e50;
            --text-secondary: #5a6c7d;
            --shadow-soft: 0 8px 32px rgba(0,0,0,0.1);
            --shadow-strong: 0 20px 60px rgba(0,0,0,0.15);
            --border-radius: 20px;
            --transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: var(--text-primary);
            background: #0f0f23;
            overflow-x: hidden;
        }

        /* Animated Background */
        .hero-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background:
                radial-gradient(circle at 20% 50%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255, 119, 198, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 40% 80%, rgba(120, 219, 226, 0.3) 0%, transparent 50%);
            animation: float 20s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            33% { transform: translateY(-20px) rotate(1deg); }
            66% { transform: translateY(10px) rotate(-1deg); }
        }

        /* Hero Section */
        .hero {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            position: relative;
            padding: 2rem;
        }

        .hero-content {
            max-width: 1200px;
            z-index: 2;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 50px;
            padding: 12px 24px;
            margin-bottom: 2rem;
            font-size: 0.9rem;
            font-weight: 500;
            color: #e0e0e0;
            animation: fadeInUp 1s ease-out;
        }

        .hero-title {
            font-size: clamp(3rem, 8vw, 6rem);
            font-weight: 900;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1.5rem;
            line-height: 1.1;
            animation: fadeInUp 1s ease-out 0.2s both;
        }

        .hero-subtitle {
            font-size: clamp(1.2rem, 3vw, 1.8rem);
            color: #b8c5d1;
            margin-bottom: 2rem;
            font-weight: 300;
            animation: fadeInUp 1s ease-out 0.4s both;
        }

        .hero-description {
            font-size: 1.25rem;
            color: #94a3b3;
            max-width: 700px;
            margin: 0 auto 3rem;
            line-height: 1.7;
            animation: fadeInUp 1s ease-out 0.6s both;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin: 3rem 0;
            animation: fadeInUp 1s ease-out 0.8s both;
        }

        .stat-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: var(--border-radius);
            padding: 2rem;
            text-align: center;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.6s;
        }

        .stat-card:hover::before {
            left: 100%;
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-strong);
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 900;
            background: var(--ocean-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            font-size: 1.2rem;
            font-weight: 700;
            color: #e0e0e0;
            margin-bottom: 0.5rem;
        }

        .stat-desc {
            color: #94a3b3;
            font-size: 0.9rem;
        }

        /* CTA Buttons */
        .hero-cta {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            animation: fadeInUp 1s ease-out 1s both;
        }

        .cta-button {
            padding: 1rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            text-decoration: none;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            position: relative;
            overflow: hidden;
        }

        .cta-button::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .cta-button:hover::before {
            width: 300px;
            height: 300px;
        }

        .cta-button.primary {
            background: var(--primary-gradient);
            color: white;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .cta-button.primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
        }

        .cta-button.secondary {
            background: transparent;
            color: #e0e0e0;
            border: 2px solid rgba(255,255,255,0.3);
        }

        .cta-button.secondary:hover {
            background: rgba(255,255,255,0.1);
            border-color: rgba(255,255,255,0.6);
        }

        /* Content Sections */
        .content-section {
            padding: 5rem 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .section-title {
            font-size: clamp(2.5rem, 5vw, 4rem);
            font-weight: 900;
            text-align: center;
            margin-bottom: 1rem;
            background: var(--sunset-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .section-subtitle {
            text-align: center;
            font-size: 1.3rem;
            color: #94a3b3;
            margin-bottom: 4rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Feature Cards */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 2rem;
            margin: 4rem 0;
        }

        .feature-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: var(--border-radius);
            padding: 2.5rem;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--primary-gradient);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .feature-card:hover::before {
            transform: scaleX(1);
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-strong);
        }

        .feature-icon {
            font-size: 3rem;
            margin-bottom: 1.5rem;
            display: block;
        }

        .feature-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: #e0e0e0;
        }

        .feature-desc {
            color: #94a3b3;
            line-height: 1.6;
        }

        /* Tech Stack */
        .tech-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin: 4rem 0;
        }

        .tech-category {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: var(--border-radius);
            padding: 2rem;
        }

        .tech-title {
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: #e0e0e0;
        }

        .tech-item {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            padding: 0.75rem;
            background: rgba(255,255,255,0.05);
            border-radius: 12px;
            transition: var(--transition);
        }

        .tech-item:hover {
            background: rgba(255,255,255,0.1);
            transform: translateX(5px);
        }

        .tech-logo {
            width: 40px;
            height: 40px;
            background: var(--tech-gradient);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
            margin-right: 1rem;
            color: var(--text-primary);
        }

        .tech-info h4 {
            font-size: 1rem;
            font-weight: 600;
            color: #e0e0e0;
            margin-bottom: 0.25rem;
        }

        .tech-info p {
            font-size: 0.85rem;
            color: #94a3b3;
        }

        /* Progress Section */
        .progress-section {
            background: var(--dark-gradient);
            padding: 5rem 2rem;
            text-align: center;
            color: white;
        }

        .progress-title {
            font-size: 3rem;
            font-weight: 900;
            margin-bottom: 2rem;
        }

        .progress-container {
            max-width: 600px;
            margin: 0 auto 2rem;
            position: relative;
        }

        .progress-bar {
            width: 100%;
            height: 24px;
            background: rgba(255,255,255,0.2);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.2);
        }

        .progress-fill {
            height: 100%;
            background: var(--ocean-gradient);
            width: 35%;
            border-radius: 12px;
            position: relative;
            transition: width 2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .progress-fill::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            animation: shimmer 2s infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }

        .progress-text {
            font-size: 1.2rem;
            margin: 2rem 0;
            opacity: 0.9;
        }

        /* Footer CTA */
        .final-cta {
            background: var(--primary-gradient);
            padding: 5rem 2rem;
            text-align: center;
            color: white;
        }

        .final-cta h2 {
            font-size: 3rem;
            font-weight: 900;
            margin-bottom: 1rem;
        }

        .final-cta p {
            font-size: 1.3rem;
            margin-bottom: 3rem;
            opacity: 0.9;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .hero {
                padding: 1rem;
            }

            .hero-title {
                font-size: 2.5rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .features-grid {
                grid-template-columns: 1fr;
            }

            .tech-grid {
                grid-template-columns: 1fr;
            }

            .hero-cta {
                flex-direction: column;
                align-items: center;
            }

            .section-title {
                font-size: 2rem;
            }
        }

        /* Scroll Indicator */
        .scroll-indicator {
            position: absolute;
            bottom: 2rem;
            left: 50%;
            transform: translateX(-50%);
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateX(-50%) translateY(0); }
            40% { transform: translateX(-50%) translateY(-10px); }
            60% { transform: translateX(-50%) translateY(-5px); }
        }
    </style>
</head>
<body>
    <div class="hero-bg"></div>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <div class="hero-badge">
                <span style="color: #4ade80; margin-right: 8px;">●</span>
                Enterprise Infrastructure Portfolio
            </div>

            <h1 class="hero-title">
                🚢 Smart Cruise Vessel<br>
                <span style="font-size: 0.8em; font-weight: 600;">IT Simulation</span>
            </h1>

            <p class="hero-subtitle">
                Integrated IT & Network Operations for Modern Maritime Infrastructure
            </p>

            <p class="hero-description">
                A production-grade simulation of enterprise IT systems powering next-generation cruise vessels.
                From Active Directory domains to IoT monitoring dashboards, this project demonstrates
                the full spectrum of enterprise infrastructure capabilities.
            </p>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">35%</div>
                    <div class="stat-label">Project Complete</div>
                    <div class="stat-desc">Foundation modules ready for implementation</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">20K+</div>
                    <div class="stat-label">IoT Nodes</div>
                    <div class="stat-desc">LED lighting system simulation</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">8</div>
                    <div class="stat-label">Automation Scripts</div>
                    <div class="stat-desc">PowerShell & Python infrastructure as code</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">5</div>
                    <div class="stat-label">Enterprise Modules</div>
                    <div class="stat-desc">Complete IT infrastructure stack</div>
                </div>
            </div>

            <div class="hero-cta">
                <a href="#architecture" class="cta-button primary">
                    🏗️ Explore Architecture
                </a>
                <a href="windows-server/README.md" class="cta-button secondary">
                    ⚡ Start Implementation
                </a>
            </div>
        </div>

        <div class="scroll-indicator">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#94a3b3" stroke-width="2">
                <path d="M7 13l3 3 3-3M7 6l3 3 3-3"/>
            </svg>
        </div>
    </section>

    <!-- Features Section -->
    <section class="content-section" id="architecture">
        <h2 class="section-title">🎯 Enterprise-Grade Architecture</h2>
        <p class="section-subtitle">
            This isn't just a demo project. It's a complete simulation of production infrastructure
            that could power a Fortune 500 enterprise or modern cruise vessel operations.
        </p>

        <div class="features-grid">
            <div class="feature-card">
                <span class="feature-icon">🏢</span>
                <h3 class="feature-title">Active Directory Domain</h3>
                <p class="feature-desc">
                    Complete Windows Server domain with multi-department user management,
                    group policies, DNS, DHCP, and enterprise file services. Everything
                    you'd find in a corporate environment.
                </p>
            </div>

            <div class="feature-card">
                <span class="feature-icon">🌐</span>
                <h3 class="feature-title">Advanced Network Design</h3>
                <p class="feature-desc">
                    Complex VLAN segmentation with OSPF routing, HSRP redundancy,
                    ACL security, and port-to-sea mode switching. Network architecture
                    that handles both harbor and open-ocean operations.
                </p>
            </div>

            <div class="feature-card">
                <span class="feature-icon">📊</span>
                <h3 class="feature-title">IoT & Analytics Platform</h3>
                <p class="feature-desc">
                    Real-time monitoring of 20,000+ LED nodes with energy analytics,
                    predictive maintenance, and operational dashboards. Python-powered
                    data simulation with realistic usage patterns.
                </p>
            </div>

            <div class="feature-card">
                <span class="feature-icon">🔧</span>
                <h3 class="feature-title">Infrastructure as Code</h3>
                <p class="feature-desc">
                    Complete automation suite with PowerShell scripts for Windows
                    administration and Python for data simulation. Reusable configurations
                    that can be deployed in any environment.
                </p>
            </div>

            <div class="feature-card">
                <span class="feature-icon">🎨</span>
                <h3 class="feature-title">Professional Documentation</h3>
                <p class="feature-desc">
                    Architecture diagrams, implementation guides, troubleshooting procedures,
                    and visual documentation. Everything needed for enterprise adoption
                    or portfolio presentation.
                </p>
            </div>

            <div class="feature-card">
                <span class="feature-icon">🚀</span>
                <h3 class="feature-title">Production Ready</h3>
                <p class="feature-desc">
                    Built with enterprise best practices, security standards, and scalability
                    in mind. Components can be directly applied to real-world infrastructure
                    projects.
                </p>
            </div>
        </div>
    </section>

    <!-- Technology Stack -->
    <section class="content-section">
        <h2 class="section-title">🛠️ Technology Arsenal</h2>
        <p class="section-subtitle">
            Industry-standard tools and technologies powering enterprise infrastructure
        </p>

        <div class="tech-grid">
            <div class="tech-category">
                <h3 class="tech-title">🏢 Infrastructure Core</h3>
                <div class="tech-item">
                    <div class="tech-logo">WS</div>
                    <div class="tech-info">
                        <h4>Windows Server 2019/2022</h4>
                        <p>Domain Controllers, File Services, Enterprise Management</p>
                    </div>
                </div>
                <div class="tech-item">
                    <div class="tech-logo">AD</div>
                    <div class="tech-info">
                        <h4>Active Directory</h4>
                        <p>Identity Management, Group Policies, Security</p>
                    </div>
                </div>
                <div class="tech-item">
                    <div class="tech-logo">VM</div>
                    <div class="tech-info">
                        <h4>VMware/Hyper-V</h4>
                        <p>Virtualization Platform, Infrastructure Scaling</p>
                    </div>
                </div>
            </div>

            <div class="tech-category">
                <h3 class="tech-title">🌐 Network Infrastructure</h3>
                <div class="tech-item">
                    <div class="tech-logo">G3</div>
                    <div class="tech-info">
                        <h4>GNS3/Cisco Packet Tracer</h4>
                        <p>Network Simulation, Topology Design</p>
                    </div>
                </div>
                <div class="tech-item">
                    <div class="tech-logo">VL</div>
                    <div class="tech-info">
                        <h4>VLANs & OSPF</h4>
                        <p>Network Segmentation, Dynamic Routing</p>
                    </div>
                </div>
                <div class="tech-item">
                    <div class="tech-logo">HS</div>
                    <div class="tech-info">
                        <h4>HSRP/VRRP</h4>
                        <p>High Availability, Gateway Redundancy</p>
                    </div>
                </div>
            </div>

            <div class="tech-category">
                <h3 class="tech-title">📊 Monitoring & Analytics</h3>
                <div class="tech-item">
                    <div class="tech-logo">GF</div>
                    <div class="tech-info">
                        <h4>Grafana + Prometheus</h4>
                        <p>Dashboards, Metrics Collection, Visualization</p>
                    </div>
                </div>
                <div class="tech-item">
                    <div class="tech-logo">PY</div>
                    <div class="tech-info">
                        <h4>Python Simulation</h4>
                        <p>IoT Data Generation, Analytics Processing</p>
                    </div>
                </div>
                <div class="tech-item">
                    <div class="tech-logo">PW</div>
                    <div class="tech-info">
                        <h4>PowerShell</h4>
                        <p>Automation Scripts, Windows Administration</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Progress Section -->
    <section class="progress-section">
        <h2 class="progress-title">📈 Development Progress</h2>

        <div class="progress-container">
            <div class="progress-bar">
                <div class="progress-fill" id="progressFill"></div>
            </div>
        </div>

        <p class="progress-text">35% Complete - Foundation Ready, Implementation Phase Starting</p>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem; max-width: 900px; margin: 3rem auto 0;">
            <div style="text-align: center; padding: 2rem; background: rgba(255,255,255,0.1); border-radius: 16px; backdrop-filter: blur(10px);">
                <div style="font-size: 2rem; font-weight: 900; color: #4ade80;">✅</div>
                <h4 style="color: #e0e0e0; margin: 1rem 0 0.5rem;">Windows Infrastructure</h4>
                <p style="color: #94a3b3; font-size: 0.9rem;">AD, DNS, DHCP, File Services</p>
            </div>
            <div style="text-align: center; padding: 2rem; background: rgba(255,255,255,0.1); border-radius: 16px; backdrop-filter: blur(10px);">
                <div style="font-size: 2rem; font-weight: 900; color: #fbbf24;">🚧</div>
                <h4 style="color: #e0e0e0; margin: 1rem 0 0.5rem;">Network Architecture</h4>
                <p style="color: #94a3b3; font-size: 0.9rem;">VLANs, Routing, Security</p>
            </div>
            <div style="text-align: center; padding: 2rem; background: rgba(255,255,255,0.1); border-radius: 16px; backdrop-filter: blur(10px);">
                <div style="font-size: 2rem; font-weight: 900; color: #94a3b3;">⏳</div>
                <h4 style="color: #e0e0e0; margin: 1rem 0 0.5rem;">IoT Monitoring</h4>
                <p style="color: #94a3b3; font-size: 0.9rem;">LED System, Analytics</p>
            </div>
        </div>
    </section>

    <!-- Final CTA -->
    <section class="final-cta">
        <h2>🚀 Ready to Dive Deep?</h2>
        <p>
            This project represents the kind of complex, mission-critical infrastructure
            that powers modern enterprises. Every component is designed with production
            environments in mind and can be directly applied to real-world scenarios.
        </p>

        <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap; margin-top: 2rem;">
            <a href="docs/architecture/windows-infrastructure.md" class="cta-button primary" style="padding: 1rem 2rem; background: white; color: #667eea; text-decoration: none; border-radius: 50px; font-weight: 600;">
                📖 Technical Architecture
            </a>
            <a href="windows-server/README.md" class="cta-button primary" style="padding: 1rem 2rem; background: rgba(255,255,255,0.2); color: white; text-decoration: none; border-radius: 50px; font-weight: 600; border: 2px solid rgba(255,255,255,0.3);">
                ⚙️ Implementation Guide
            </a>
            <a href="docs/project-plan.md" class="cta-button primary" style="padding: 1rem 2rem; background: transparent; color: white; text-decoration: none; border-radius: 50px; font-weight: 600; border: 2px solid rgba(255,255,255,0.6);">
                📋 Project Roadmap
            </a>
        </div>
    </section>

    <script>
        // Animate progress bar
        document.addEventListener('DOMContentLoaded', function() {
            const progressFill = document.getElementById('progressFill');
            setTimeout(() => {
                progressFill.style.width = '35%';
            }, 500);
        });

        // Smooth scrolling
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Intersection Observer for animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        // Observe all feature cards and tech items
        document.querySelectorAll('.feature-card, .tech-item').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(30px)';
            el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            observer.observe(el);
        });

        // Add particle effect to hero
        function createParticle() {
            const particle = document.createElement('div');
            particle.style.position = 'absolute';
            particle.style.width = Math.random() * 4 + 'px';
            particle.style.height = particle.style.width;
            particle.style.background = 'rgba(255,255,255,0.1)';
            particle.style.borderRadius = '50%';
            particle.style.left = Math.random() * 100 + '%';
            particle.style.top = '100%';
            particle.style.animation = `float ${Math.random() * 10 + 10}s linear infinite`;

            document.querySelector('.hero-bg').appendChild(particle);

            setTimeout(() => {
                particle.remove();
            }, 15000);
        }

        // Create particles periodically
        setInterval(createParticle, 2000);
    </script>
</body>
</html>

---

## 🎯 Core Objectives

1. **Technical Excellence:** Demonstrate proficiency in enterprise Windows Server administration, network design, and monitoring systems
2. **Real-World Relevance:** Show understanding of maritime IT challenges and cruise vessel operational requirements
3. **Portfolio Quality:** Create a comprehensive, professional portfolio showcasing end-to-end IT infrastructure management
4. **Industry Alignment:** Align with current cruise industry technology trends and best practices

---

## 📦 Project Modules

### **Module A — Windows & Departmental Systems** 🚧 In Progress
- Enterprise Windows Server infrastructure (AD, DNS, DHCP)
- Multi-department client environments (Deck, Engine, Hotel, Guest Services)
- Centralized identity and access management
- Group Policy Objects (GPOs) and file services
- IT support workflows and procedures

**Status:** Foundation setup in progress | [View Details](docs/architecture/windows-infrastructure.md)

### **Module B — Network Infrastructure & Zoning** 📅 Planned
- Segmented network architecture with VLANs
- High-availability router/switch setup
- Port mode vs Sea mode network operation
- Network resilience and failover scenarios

### **Module C — Monitoring, Data Analytics & IoT** 📅 Planned
- Comprehensive infrastructure monitoring
- IoT data collection (20,000+ LED nodes)
- Energy consumption analytics
- Operational dashboards (Grafana/Power BI)

### **Module D — Guest/Service Experience & Collaboration** 📅 Planned
- Real-world incident response scenarios
- Multi-department collaboration workflows
- Customer service excellence documentation
- Troubleshooting procedures and runbooks

### **Module E — Documentation & Presentation** 📅 Planned
- Complete project documentation
- Professional diagrams and screenshots
- GitHub portfolio optimization
- LinkedIn content and reflections

---

## 📁 Repository Structure

```
RCG/
├── README.md                          # Project overview (this file)
├── LICENSE                            # Project license
│
├── docs/                              # Documentation
│   ├── project-plan.md                # Comprehensive project plan
│   ├── architecture/                  # Architecture documents
│   │   ├── windows-infrastructure.md  # Windows Server architecture
│   │   ├── network-architecture.md   # Network design (coming soon)
│   │   └── monitoring-architecture.md # Monitoring setup (coming soon)
│   ├── diagrams/                      # Network and system diagrams
│   ├── dashboards/                    # Dashboard screenshots
│   ├── procedures/                    # Operational procedures
│   ├── scenarios/                     # Incident scenarios
│   └── reports/                       # Analysis reports
│
├── windows-server/                    # Windows Server module
│   ├── screenshots/                   # Configuration screenshots
│   ├── scripts/                       # PowerShell automation scripts
│   └── configs/                       # Configuration files
│
├── network-simulation/                 # Network module
│   ├── configs/                       # Router/switch configurations
│   └── gns3-project/                  # GNS3 project files
│
├── monitoring-dashboard/               # Monitoring module
│   └── data-simulation-scripts/       # IoT data simulation
│
├── automation-scripts/                 # Automation scripts
│   ├── powershell/                    # PowerShell scripts
│   └── python/                        # Python scripts
│
└── assets/                            # Media assets
    ├── screenshots/                   # General screenshots
    └── videos/                        # Video walkthroughs
```

---

## 🚀 Quick Start

### Prerequisites
- Windows Server 2019/2022 (VMs or physical)
- Windows 10/11 client VMs
- Virtualization platform (VMware, VirtualBox, or Hyper-V)
- Network simulation tool (GNS3, Packet Tracer, or EVE-NG)
- Monitoring platform (Grafana, Zabbix, or Power BI)

### Getting Started
1. Review the [Project Plan](docs/project-plan.md) for comprehensive details
2. Check [Windows Infrastructure Guide](docs/architecture/windows-infrastructure.md) for Module A setup
3. Follow module-specific documentation in each directory
4. Refer to procedures in `/docs/procedures/` for operational workflows

---

## 🧰 Technologies & Tools

### Infrastructure
- **Windows Server 2019/2022** - Domain Controllers, File Servers, DNS/DHCP
- **Windows 10/11** - Client workstations
- **VMware/VirtualBox/Hyper-V** - Virtualization

### Networking
- **GNS3/Packet Tracer/EVE-NG** - Network simulation
- **Cisco IOS** - Router/switch configurations
- **VLANs, OSPF, HSRP/VRRP** - Network protocols

### Monitoring & Analytics
- **Grafana + Prometheus/InfluxDB** - Monitoring dashboards
- **Zabbix** - Infrastructure monitoring
- **Power BI** - Business analytics

### Automation
- **PowerShell** - Windows administration automation
- **Python** - Data simulation and analysis

### Documentation
- **Markdown** - Documentation format
- **draw.io/diagrams.net** - Architecture diagrams

---

## 📊 Project Status

| Module | Status | Progress | Documentation |
|--------|--------|----------|---------------|
| Module A | 🚧 In Progress | 20% | [Windows Infrastructure](docs/architecture/windows-infrastructure.md) |
| Module B | 📅 Planned | 0% | Coming soon |
| Module C | 📅 Planned | 0% | Coming soon |
| Module D | 📅 Planned | 0% | Coming soon |
| Module E | 📅 Planned | 0% | Coming soon |

**Legend:** 🚧 In Progress | ✅ Complete | 📅 Planned | ⏸️ On Hold

---

## 📈 Success Metrics

### Technical Metrics
- ✅ All modules completed with 100% of defined deliverables
- ✅ Zero critical bugs in production simulation
- ✅ All systems meet performance benchmarks
- ✅ Documentation coverage > 90%

### Portfolio Metrics
- ✅ GitHub repository with 50+ commits
- ✅ 20+ professional screenshots
- ✅ 10+ architecture diagrams
- ✅ 3+ functional dashboards
- ✅ 2+ video walkthroughs

---

## 📚 Documentation

- **[Project Plan](docs/project-plan.md)** - Comprehensive project plan with timelines, modules, and success criteria
- **[Windows Infrastructure](docs/architecture/windows-infrastructure.md)** - Module A architecture and setup guide
- **Network Architecture** - Coming soon (Module B)
- **Monitoring Architecture** - Coming soon (Module C)
- **IT Support Workflows** - Coming soon (Module A)

---

## 🔗 Weekly Updates

This project is documented weekly with progress updates, technical insights, and lessons learned. Follow the journey:

- **Week 1:** Project launch and Module A foundation
- **Week 2:** Complete Windows infrastructure
- **Week 3:** Network infrastructure implementation
- **Week 4:** Monitoring and analytics dashboards
- **Week 5:** Incident response scenarios
- **Week 6:** Documentation and portfolio completion

---

## 🤝 Contributing

This is a portfolio project, but suggestions and feedback are welcome! If you have ideas for improvements or want to collaborate, please open an issue or discussion.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📫 Contact & Links

- **LinkedIn:** [Your LinkedIn Profile]
- **Email:** [Your Email]
- **Portfolio:** [Your Portfolio URL]

---

## 🙏 Acknowledgments

- Inspired by modern Icon-Class cruise vessels
- Built with industry best practices and maritime IT standards
- Tools and technologies used are industry-standard enterprise solutions

---

**Last Updated:** 2024 | **Version:** 1.0.0 | **Status:** Active Development
