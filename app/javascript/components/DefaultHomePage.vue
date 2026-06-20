<template>
  <div class="root">

    <!-- ── ANIMATED BACKGROUND ORBS ─────────────────────────── -->
    <div class="orbs" aria-hidden="true">
      <div class="orb orb-purple"></div>
      <div class="orb orb-blue"></div>
      <div class="orb orb-teal"></div>
      <div class="orb orb-rose"></div>
    </div>

    <!-- Grid overlay -->
    <div class="grid-overlay" aria-hidden="true"></div>

    <!-- ── HERO ──────────────────────────────────────────────── -->
    <header class="hero">

      <!-- Logo -->
      <div class="logo-wrap">
        <div class="logo-glow"></div>
        <div class="logo-icon">
          <svg viewBox="0 0 28 28" fill="none" width="20" height="20">
            <path d="M7 21V7h8.5c4 0 6.5 2.2 6.5 5.5s-2 5-5 5.5L22 21h-4l-4.5-3.5H11V21Z" fill="white"/>
            <path d="M11 7v7.2h3.8c2.2 0 3.5-.9 3.5-2.4 0-1.4-1.3-2.3-3.5-2.3H11" fill="#991005" opacity="0.9"/>
          </svg>
        </div>
      </div>

      <!-- Title -->
      <h1 class="hero-title">All In One Rails</h1>
      <p class="hero-sub">Full · Stack · Production · Ready · Open · Source</p>

      <!-- Badge row -->
      <div class="badge-row">
        <span class="badge badge-green">
          <span class="badge-dot badge-dot-pulse"></span>
          Online
        </span>
        <span class="badge badge-red">Rails 8.1.3</span>
        <span class="badge badge-green">Vue 3.5.38</span>
        <span class="badge badge-blue">PostgreSQL 17.6</span>
        <span class="badge badge-purple">Sidekiq 8.1.6</span>
        <span class="badge badge-amber">
          <span class="badge-dot"></span>
          ClickHouse · Disabled
        </span>
      </div>
    </header>

    <!-- ── CARDS GRID ─────────────────────────────────────────── -->
    <main class="cards-grid">
      <div
        v-for="(cat, i) in techStack"
        :key="cat.name"
        class="card"
        :class="{ 'card--visible': visible[i] }"
        :style="{ '--accent': cat.color, transitionDelay: `${i * 70}ms` }"
      >
        <!-- Shimmer border -->
        <div class="card-shimmer"></div>

        <!-- Top accent line -->
        <div class="card-line"></div>

        <div class="card-body">
          <!-- Header -->
          <div class="card-head">
            <div class="card-head-left">
              <span class="card-pip"></span>
              <span class="card-label">{{ cat.name }}</span>
            </div>
            <span class="card-count">{{ cat.items.length }} PKG</span>
          </div>

          <!-- Items -->
          <ul class="card-items">
            <li v-for="item in cat.items" :key="item.name" class="card-item">
              <div class="item-left">
                <span class="item-dot"></span>
                <span class="item-name">{{ item.name }}</span>
              </div>
              <div class="item-right">
                <span v-if="item.flag" class="item-flag">FLAG</span>
                <span v-if="item.version" class="item-version">{{ item.version }}</span>
                <span v-else-if="!item.flag" class="item-dash">—</span>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </main>

    <!-- ── FOOTER ─────────────────────────────────────────────── -->
    <footer class="footer">
      <div class="footer-stats">
        <div v-for="s in footerStats" :key="s.label" class="footer-stat">
          <span class="footer-dot" :style="{ background: s.color }"></span>
          <span class="footer-label">{{ s.label }}</span>
          <span class="footer-version" :style="{ color: s.color }">{{ s.version }}</span>
        </div>
      </div>
      <p class="footer-credit">
        Developed &amp; owned by <span>Muneeb Ahmad Farooqi</span> · © 2026
      </p>
    </footer>

  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const visible = ref([])

onMounted(() => {
  const total = techStack.length
  for (let i = 0; i < total; i++) {
    setTimeout(() => { visible.value[i] = true }, 100 + i * 70)
  }
})

const techStack = [
  {
    name: 'Backend',
    color: '#f87171',
    items: [
      { name: 'Ruby',              version: '3.4.6'  },
      { name: 'Ruby on Rails',     version: '8.1.3'  },
      { name: 'PostgreSQL',        version: '17.6'   },
      { name: 'pg (adapter)',      version: '1.6.3'  },
      { name: 'UUID · pgcrypto',   version: null     },
    ],
  },
  {
    name: 'Frontend',
    color: '#34d399',
    items: [
      { name: 'Vue.js',            version: '3.5.38' },
      { name: 'Vue Router',        version: '5.1.0'  },
      { name: 'Pinia',             version: '3.0.4'  },
      { name: 'Tailwind CSS',      version: '4.3.1'  },
      { name: 'Vite',              version: '8.0.16' },
    ],
  },
  {
    name: 'Hotwire',
    color: '#fbbf24',
    items: [
      { name: '@hotwired/turbo',    version: '8.0.23' },
      { name: 'turbo-rails',        version: '2.0.23' },
      { name: '@hotwired/stimulus', version: '3.2.2'  },
      { name: 'stimulus-rails',     version: '1.3.4'  },
    ],
  },
  {
    name: 'Background & Queue',
    color: '#60a5fa',
    items: [
      { name: 'Sidekiq',            version: '8.1.6'  },
      { name: 'sidekiq-failures',   version: '1.1.0'  },
      { name: 'Redis · valkey',     version: '8'      },
      { name: 'Solid Cache',        version: '1.0.10' },
      { name: 'Solid Cable',        version: '4.0.0'  },
    ],
  },
  {
    name: 'Infrastructure',
    color: '#c084fc',
    items: [
      { name: 'Puma',                     version: '8.0.2'  },
      { name: 'Thruster',                 version: '0.1.21' },
      { name: 'Propshaft',                version: '1.3.2'  },
      { name: 'Kamal',                    version: '2.12.0' },
      { name: 'image_processing',         version: '2.0.2'  },
      { name: 'mini_magick',              version: '5.3.1'  },
      { name: 'clickhouse-activerecord',  version: '1.6.7', flag: true },
    ],
  },
  {
    name: 'Dev Tools',
    color: '#22d3ee',
    items: [
      { name: 'Dev Container · PG + Redis', version: null    },
      { name: 'Vite Ruby',                version: '3.11.0' },
      { name: 'Foreman',                  version: '0.90.0' },
      { name: 'GitHub Actions',           version: null     },
      { name: 'Brakeman · bundler-audit', version: null     },
      { name: 'RuboCop Omakase',          version: null     },
    ],
  },
]

const footerStats = [
  { label: 'RAILS',    version: '8.1.3',  color: '#f87171' },
  { label: 'VUE',      version: '3.5.38', color: '#34d399' },
  { label: 'PG',       version: '17.6',   color: '#60a5fa' },
  { label: 'TAILWIND', version: '4.3.1',  color: '#22d3ee' },
  { label: 'VITE',     version: '8.0.16', color: '#c084fc' },
  { label: 'RUBY',     version: '3.4.6',  color: '#fbbf24' },
]
</script>

<style scoped>
/* ── ROOT ─────────────────────────────────────────────────────── */
.root {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: #04060f;
  color: white;
  overflow-x: hidden;
  font-family: system-ui, -apple-system, sans-serif;
}

/* ── ANIMATED ORBS ───────────────────────────────────────────── */
.orbs {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 0;
  overflow: hidden;
}

.orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(100px);
}

.orb-purple {
  width: 650px; height: 650px;
  background: radial-gradient(circle, #7c3aed 0%, transparent 70%);
  top: -200px; left: -150px;
  opacity: 0.18;
  animation: drift 22s ease-in-out infinite;
}

.orb-blue {
  width: 500px; height: 500px;
  background: radial-gradient(circle, #1d4ed8 0%, transparent 70%);
  top: 10%; right: -150px;
  opacity: 0.14;
  animation: drift 28s ease-in-out infinite reverse;
}

.orb-teal {
  width: 420px; height: 420px;
  background: radial-gradient(circle, #0d9488 0%, transparent 70%);
  bottom: -80px; left: 25%;
  opacity: 0.12;
  animation: drift 35s ease-in-out infinite 4s;
}

.orb-rose {
  width: 300px; height: 300px;
  background: radial-gradient(circle, #be185d 0%, transparent 70%);
  bottom: 20%; right: 10%;
  opacity: 0.10;
  animation: drift 18s ease-in-out infinite 2s reverse;
}

@keyframes drift {
  0%, 100% { transform: translate(0, 0) scale(1); }
  25%       { transform: translate(40px, -60px) scale(1.06); }
  50%       { transform: translate(-30px, 40px) scale(0.94); }
  75%       { transform: translate(20px, 30px) scale(1.03); }
}

/* ── GRID OVERLAY ────────────────────────────────────────────── */
.grid-overlay {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 1;
  background-image:
    linear-gradient(rgba(255,255,255,0.025) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255,255,255,0.025) 1px, transparent 1px);
  background-size: 44px 44px;
}

/* ── HERO ────────────────────────────────────────────────────── */
.hero {
  position: relative;
  z-index: 10;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  padding: 52px 24px 36px;
}

.logo-wrap {
  position: relative;
  width: 56px;
  height: 56px;
  margin-bottom: 20px;
}

.logo-glow {
  position: absolute;
  inset: -8px;
  border-radius: 18px;
  background: rgba(239, 68, 68, 0.4);
  filter: blur(18px);
  animation: logo-pulse 3s ease-in-out infinite;
}

@keyframes logo-pulse {
  0%, 100% { opacity: 0.4; transform: scale(1); }
  50%       { opacity: 0.7; transform: scale(1.1); }
}

.logo-icon {
  position: relative;
  width: 56px;
  height: 56px;
  border-radius: 16px;
  background: linear-gradient(135deg, #ef4444 0%, #991b1b 100%);
  box-shadow: 0 0 0 1px rgba(239,68,68,0.35), 0 8px 32px rgba(239,68,68,0.25);
  display: flex;
  align-items: center;
  justify-content: center;
}

.hero-title {
  font-size: clamp(2rem, 5vw, 3.75rem);
  font-weight: 900;
  letter-spacing: -0.02em;
  line-height: 1.1;
  margin: 0 0 12px;
  background: linear-gradient(135deg, #ffffff 0%, #c4b5fd 30%, #7dd3fc 60%, #6ee7b7 100%);
  background-size: 300% 300%;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: title-gradient 7s ease infinite;
}

@keyframes title-gradient {
  0%   { background-position: 0% 50%; }
  50%  { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.hero-sub {
  font-size: 10px;
  font-family: 'SF Mono', 'Fira Code', monospace;
  letter-spacing: 0.3em;
  color: rgba(255,255,255,0.28);
  text-transform: uppercase;
  margin: 0 0 28px;
}

/* ── BADGES ──────────────────────────────────────────────────── */
.badge-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  justify-content: center;
}

.badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 10px;
  font-family: 'SF Mono', 'Fira Code', monospace;
  font-weight: 600;
  letter-spacing: 0.05em;
  padding: 5px 12px;
  border-radius: 100px;
}

.badge-green  { background: rgba(52,211,153,0.1);  border: 1px solid rgba(52,211,153,0.25);  color: #34d399; }
.badge-red    { background: rgba(248,113,113,0.1);  border: 1px solid rgba(248,113,113,0.25); color: #f87171; }
.badge-blue   { background: rgba(96,165,250,0.1);  border: 1px solid rgba(96,165,250,0.25);  color: #60a5fa; }
.badge-purple { background: rgba(192,132,252,0.1); border: 1px solid rgba(192,132,252,0.25); color: #c084fc; }
.badge-amber  { background: rgba(251,191,36,0.08); border: 1px solid rgba(251,191,36,0.2);   color: rgba(251,191,36,0.7); }

.badge-dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: currentColor;
}

.badge-dot-pulse {
  animation: dot-pulse 2s ease-in-out infinite;
}

@keyframes dot-pulse {
  0%, 100% { opacity: 1;   transform: scale(1); }
  50%       { opacity: 0.4; transform: scale(0.8); }
}

/* ── CARDS GRID ──────────────────────────────────────────────── */
.cards-grid {
  position: relative;
  z-index: 10;
  flex: 1;
  display: grid;
  grid-template-columns: 1fr;
  gap: 10px;
  padding: 0 10px 10px;
}

@media (min-width: 640px) {
  .cards-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (min-width: 1024px) {
  .cards-grid { grid-template-columns: repeat(3, 1fr); }
}

/* ── CARD ────────────────────────────────────────────────────── */
.card {
  position: relative;
  border-radius: 16px;
  overflow: hidden;
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.55s ease, transform 0.55s ease, box-shadow 0.3s ease, border-color 0.3s ease;
  border: 1px solid rgba(255,255,255,0.07);
  background: rgba(255,255,255,0.025);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  cursor: default;
}

.card--visible {
  opacity: 1;
  transform: translateY(0);
}

.card:hover {
  border-color: color-mix(in srgb, var(--accent) 30%, transparent);
  box-shadow:
    0 0 0 1px color-mix(in srgb, var(--accent) 15%, transparent),
    0 12px 48px rgba(0,0,0,0.4),
    0 0 60px color-mix(in srgb, var(--accent) 5%, transparent);
  transform: translateY(-3px);
}

/* Shimmer on hover */
.card-shimmer {
  position: absolute;
  inset: 0;
  border-radius: 16px;
  opacity: 0;
  transition: opacity 0.4s ease;
  background: linear-gradient(
    135deg,
    transparent 0%,
    color-mix(in srgb, var(--accent) 4%, transparent) 50%,
    transparent 100%
  );
  pointer-events: none;
}
.card:hover .card-shimmer { opacity: 1; }

/* Top accent line */
.card-line {
  height: 2px;
  background: linear-gradient(to right, var(--accent), transparent);
  opacity: 0.6;
  transition: opacity 0.3s ease;
}
.card:hover .card-line { opacity: 1; }

.card-body {
  padding: 14px 16px 16px;
  display: flex;
  flex-direction: column;
  height: calc(100% - 2px);
}

/* Card header */
.card-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.card-head-left {
  display: flex;
  align-items: center;
  gap: 8px;
}

.card-pip {
  display: block;
  width: 3px;
  height: 14px;
  border-radius: 2px;
  background: var(--accent);
  box-shadow: 0 0 8px var(--accent);
}

.card-label {
  font-size: 9.5px;
  font-family: 'SF Mono', 'Fira Code', monospace;
  font-weight: 700;
  letter-spacing: 0.22em;
  text-transform: uppercase;
  color: var(--accent);
}

.card-count {
  font-size: 7.5px;
  font-family: 'SF Mono', 'Fira Code', monospace;
  letter-spacing: 0.15em;
  color: rgba(255,255,255,0.14);
}

/* Items */
.card-items {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 7px;
}

.card-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}

.item-left {
  display: flex;
  align-items: center;
  gap: 7px;
  min-width: 0;
}

.item-dot {
  width: 3px;
  height: 3px;
  border-radius: 50%;
  background: var(--accent);
  opacity: 0.3;
  flex-shrink: 0;
  transition: opacity 0.2s;
}
.card-item:hover .item-dot { opacity: 0.8; }

.item-name {
  font-size: 11px;
  color: rgba(255,255,255,0.45);
  font-weight: 500;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  transition: color 0.2s;
}
.card-item:hover .item-name { color: rgba(255,255,255,0.72); }

.item-right {
  display: flex;
  align-items: center;
  gap: 4px;
  flex-shrink: 0;
}

.item-version {
  font-size: 9px;
  font-family: 'SF Mono', 'Fira Code', monospace;
  color: rgba(255,255,255,0.28);
  background: rgba(255,255,255,0.04);
  border: 1px solid rgba(255,255,255,0.06);
  border-radius: 4px;
  padding: 1.5px 6px;
  white-space: nowrap;
}

.item-flag {
  font-size: 7px;
  font-family: 'SF Mono', 'Fira Code', monospace;
  color: rgba(251,191,36,0.65);
  background: rgba(251,191,36,0.08);
  border: 1px solid rgba(251,191,36,0.18);
  border-radius: 3px;
  padding: 1px 5px;
  letter-spacing: 0.05em;
}

.item-dash {
  font-size: 9px;
  color: rgba(255,255,255,0.12);
}

/* ── FOOTER ──────────────────────────────────────────────────── */
.footer {
  position: relative;
  z-index: 10;
  padding: 12px 20px;
  border-top: 1px solid rgba(255,255,255,0.06);
  background: rgba(4,6,15,0.7);
  backdrop-filter: blur(12px);
  display: flex;
  flex-direction: column;
  gap: 8px;
  align-items: center;
  text-align: center;
}

@media (min-width: 640px) {
  .footer {
    flex-direction: row;
    justify-content: space-between;
    text-align: left;
  }
}

.footer-stats {
  display: flex;
  flex-wrap: wrap;
  gap: 12px 18px;
  justify-content: center;
}

.footer-stat {
  display: flex;
  align-items: center;
  gap: 5px;
}

.footer-dot {
  width: 3px;
  height: 3px;
  border-radius: 50%;
}

.footer-label {
  font-size: 8px;
  font-family: 'SF Mono', 'Fira Code', monospace;
  color: rgba(255,255,255,0.2);
  letter-spacing: 0.18em;
}

.footer-version {
  font-size: 8px;
  font-family: 'SF Mono', 'Fira Code', monospace;
  font-weight: 600;
  letter-spacing: 0.08em;
  opacity: 0.75;
}

.footer-credit {
  font-size: 8px;
  font-family: 'SF Mono', 'Fira Code', monospace;
  color: rgba(255,255,255,0.14);
  letter-spacing: 0.15em;
  margin: 0;
  white-space: nowrap;
}

.footer-credit span {
  color: rgba(255,255,255,0.3);
}
</style>
