<template>
  <div
    class="min-h-screen lg:h-screen lg:overflow-hidden flex flex-col bg-[#030a14] text-white"
    style="background-image: radial-gradient(circle, rgba(99,102,241,0.065) 1px, transparent 1px); background-size: 28px 28px;"
  >

    <!-- Top ambient glow -->
    <div
      class="fixed top-0 left-1/2 -translate-x-1/2 w-full sm:w-[900px] h-[220px] sm:h-[280px] pointer-events-none"
      style="background: radial-gradient(ellipse at center top, rgba(255,45,32,0.055) 0%, transparent 68%);"
    ></div>

    <!-- CRT scanlines overlay -->
    <div
      class="fixed inset-0 pointer-events-none z-40 opacity-30"
      style="background: repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(0,0,0,0.07) 2px, rgba(0,0,0,0.07) 4px);"
    ></div>

    <!-- ── HEADER ──────────────────────────────────────────────── -->
    <header class="relative z-10 shrink-0 border-b border-white/[0.05]
                   px-4 py-3 sm:px-5 sm:py-[11px]
                   flex flex-row items-center justify-between">

      <!-- Left: logo + title -->
      <div class="flex items-center gap-3">
        <div class="relative shrink-0">
          <div class="absolute inset-0 rounded-[10px] blur-lg" style="background: rgba(255,45,32,0.35);"></div>
          <div class="relative w-8 h-8 rounded-[10px] flex items-center justify-center"
               style="background: linear-gradient(135deg, #ff5040 0%, #cc1a0a 100%);">
            <svg viewBox="0 0 28 28" class="w-[17px] h-[17px]" fill="none">
              <path d="M7 21V7h8.5c4 0 6.5 2.2 6.5 5.5s-2 5-5 5.5L22 21h-4l-4.5-3.5H11V21Z" fill="white"/>
              <path d="M11 7v7.2h3.8c2.2 0 3.5-.9 3.5-2.4 0-1.4-1.3-2.3-3.5-2.3H11" fill="#991005" opacity="0.9"/>
            </svg>
          </div>
        </div>

        <div class="leading-none">
          <p class="text-[12.5px] font-bold tracking-[0.18em] uppercase text-white/90">All In One Rails</p>
          <p class="hidden sm:block text-[8.5px] font-mono text-white/22 tracking-[0.32em] mt-[3px]">FULL·STACK · PRODUCTION·READY</p>
        </div>
      </div>

      <!-- Right -->
      <div class="flex items-center gap-3 sm:gap-6">

        <!-- System stats — hidden on mobile, visible sm+ -->
        <div class="hidden sm:flex items-center gap-4 lg:gap-5 font-mono text-[9px] tracking-widest">
          <span class="text-white/22">RUBY&nbsp;<span class="text-white/50">3.4.6</span></span>
          <span class="hidden md:inline text-white/22">NODE&nbsp;<span class="text-white/50">20 LTS</span></span>
          <span class="hidden lg:inline text-white/22">DOCKER&nbsp;<span class="text-white/50">PG 17.6</span></span>
        </div>

        <!-- Online indicator — always visible -->
        <div class="flex items-center gap-[7px] sm:pl-5 sm:border-l sm:border-white/[0.07]">
          <span class="w-[5px] h-[5px] rounded-full bg-emerald-400 animate-pulse"></span>
          <span class="text-[9px] font-mono tracking-[0.25em] text-emerald-400/75">ONLINE</span>
        </div>
      </div>
    </header>

    <!-- ── MAIN GRID ───────────────────────────────────────────── -->
    <main class="relative z-10 grid gap-[10px] p-[10px]
                 grid-cols-1 sm:grid-cols-2 lg:grid-cols-3
                 lg:grid-rows-2 lg:flex-1 lg:min-h-0">

      <div
        v-for="cat in techStack"
        :key="cat.name"
        class="relative rounded-xl flex flex-col cursor-default group
               transition-all duration-300 hover:-translate-y-px
               overflow-hidden lg:overflow-hidden"
        :style="{
          background: 'rgba(255,255,255,0.016)',
          border: `1px solid ${cat.color}28`,
        }"
      >
        <!-- Gradient top accent -->
        <div
          class="h-[1.5px] w-full shrink-0 opacity-75 group-hover:opacity-100 transition-opacity duration-300"
          :style="{ background: `linear-gradient(to right, ${cat.color}, ${cat.color}33)` }"
        ></div>

        <!-- Hover inner glow -->
        <div
          class="absolute inset-0 rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none"
          :style="{ boxShadow: `inset 0 0 35px ${cat.color}0a, 0 0 18px ${cat.color}06` }"
        ></div>

        <!-- Card body -->
        <div class="flex flex-col p-[14px] pt-[12px] lg:flex-1 lg:min-h-0">

          <!-- Card header -->
          <div class="flex items-center justify-between mb-[10px] shrink-0">
            <div class="flex items-center gap-[9px]">
              <div class="w-[3px] h-[14px] rounded-full" :style="{ background: cat.color }"></div>
              <span
                class="text-[9.5px] font-bold tracking-[0.22em] uppercase"
                :style="{ color: cat.color }"
              >{{ cat.name }}</span>
            </div>
            <span class="text-[7.5px] font-mono text-white/15 tracking-widest">
              {{ cat.items.length }}&nbsp;PKG
            </span>
          </div>

          <!-- Items list -->
          <div class="flex flex-col gap-[7px] lg:flex-1 lg:min-h-0 lg:overflow-hidden">
            <div
              v-for="item in cat.items"
              :key="item.name"
              class="flex items-center justify-between gap-2 group/row"
            >
              <div class="flex items-center gap-[7px] min-w-0">
                <span
                  class="w-[3px] h-[3px] rounded-full shrink-0 opacity-35"
                  :style="{ background: cat.color }"
                ></span>
                <span class="text-[11.5px] sm:text-[11px] text-white/52 font-medium truncate
                             group-hover/row:text-white/72 transition-colors duration-150">
                  {{ item.name }}
                </span>
              </div>
              <span
                v-if="item.version"
                class="text-[9px] font-mono shrink-0 px-[6px] py-[1.5px] rounded text-white/28 whitespace-nowrap"
                style="background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.06);"
              >{{ item.version }}</span>
              <span v-else class="text-[9px] font-mono text-white/16 shrink-0">—</span>
            </div>
          </div>

        </div>
      </div>
    </main>

    <!-- ── FOOTER ──────────────────────────────────────────────── -->
    <footer class="relative z-10 shrink-0 border-t border-white/[0.05] px-4 py-3 sm:px-5 sm:py-[9px]">

      <!-- Stats row — wraps on mobile -->
      <div class="flex flex-wrap gap-x-4 gap-y-[7px] sm:gap-x-[18px] mb-2 sm:mb-0 sm:inline-flex sm:items-center">
        <div
          v-for="stat in footerStats"
          :key="stat.label"
          class="flex items-center gap-[6px]"
        >
          <span class="w-[3.5px] h-[3.5px] rounded-full" :style="{ background: stat.color }"></span>
          <span class="text-[8.5px] font-mono text-white/18 tracking-[0.18em]">{{ stat.label }}</span>
          <span class="text-[8.5px] font-mono tracking-wide font-semibold" :style="{ color: stat.color + 'bb' }">
            {{ stat.version }}
          </span>
        </div>
      </div>

      <!-- Attribution -->
      <div class="sm:hidden mt-3 pt-2.5 border-t border-white/[0.05]
                  flex flex-col items-center gap-[4px] text-center">
        <span class="text-[8px] font-mono text-white/18 tracking-[0.22em]">DEVELOPED &amp; OWNED BY</span>
        <span class="text-[10px] font-mono text-white/40 tracking-[0.15em] font-semibold">MUNEEB AHMAD FAROOQI</span>
        <span class="text-[7.5px] font-mono text-white/14 tracking-[0.2em] mt-0.5">© 2026</span>
      </div>

      <!-- Desktop attribution (single line) -->
      <div class="hidden sm:flex items-center justify-between mt-0">
        <!-- spacer to push attribution right on desktop when stats are inline -->
        <div class="sm:hidden"></div>
        <span class="text-[7.5px] font-mono text-white/14 tracking-[0.2em] sm:ml-auto">
          DEVELOPED &amp; OWNED BY
          <span class="text-white/32 ml-1">MUNEEB AHMAD FAROOQI</span>
          <span class="text-white/14 ml-2">· © 2026</span>
        </span>
      </div>

    </footer>

  </div>
</template>

<script setup>
const techStack = [
  {
    name: 'Backend',
    color: '#ff4d3d',
    items: [
      { name: 'Ruby',              version: '3.4.6'   },
      { name: 'Ruby on Rails',     version: '8.1.3'   },
      { name: 'PostgreSQL',        version: '17.6'    },
      { name: 'pg (adapter)',      version: '1.6.3'   },
      { name: 'UUID · pgcrypto',   version: null      },
    ],
  },
  {
    name: 'Frontend',
    color: '#42d392',
    items: [
      { name: 'Vue.js',            version: '3.5.34'  },
      { name: 'Vue Router',        version: '4.6.4'   },
      { name: 'Pinia',             version: '2.3.1'   },
      { name: 'Tailwind CSS',      version: '4.3.0'   },
      { name: 'Vite',              version: '8.0.14'  },
    ],
  },
  {
    name: 'Hotwire',
    color: '#fbbf24',
    items: [
      { name: '@hotwired/turbo',   version: '8.0.23'  },
      { name: 'turbo-rails',       version: '2.0.23'  },
      { name: '@hotwired/stimulus',version: '3.2.2'   },
      { name: 'stimulus-rails',    version: '1.3.4'   },
    ],
  },
  {
    name: 'Solid Stack',
    color: '#60a5fa',
    items: [
      { name: 'Solid Queue',       version: '1.4.0'   },
      { name: 'Solid Cache',       version: '1.0.10'  },
      { name: 'Solid Cable',       version: '3.0.12'  },
    ],
  },
  {
    name: 'Infrastructure',
    color: '#c084fc',
    items: [
      { name: 'Puma',              version: '8.0.1'   },
      { name: 'Thruster',          version: '0.1.21'  },
      { name: 'Propshaft',         version: '1.3.2'   },
      { name: 'Kamal',             version: '2.11.0'  },
      { name: 'image_processing',  version: '1.14.0'  },
    ],
  },
  {
    name: 'Dev Tools',
    color: '#22d3ee',
    items: [
      { name: 'Dev Container · PG 17.6', version: null },
      { name: 'Vite Ruby',         version: '3.11.0'  },
      { name: 'GitHub Actions',    version: null      },
      { name: 'Brakeman · bundler-audit', version: null },
      { name: 'RuboCop Omakase',   version: null      },
    ],
  },
]

const footerStats = [
  { label: 'RAILS',    version: '8.1.3',  color: '#ff4d3d' },
  { label: 'VUE',      version: '3.5.34', color: '#42d392' },
  { label: 'PG',       version: '17.6',   color: '#60a5fa' },
  { label: 'TAILWIND', version: '4.3.0',  color: '#22d3ee' },
  { label: 'VITE',     version: '8.0.14', color: '#c084fc' },
  { label: 'RUBY',     version: '3.4.6',  color: '#fbbf24' },
]
</script>
