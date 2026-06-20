import { describe, it, expect, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { nextTick } from 'vue'
import DefaultHomePage from '../../../app/javascript/components/DefaultHomePage.vue'

describe('DefaultHomePage', () => {
  let wrapper

  beforeEach(() => {
    wrapper = mount(DefaultHomePage)
  })

  // ── Rendering ───────────────────────────────────────────────

  it('renders the app title', () => {
    expect(wrapper.find('.hero-title').text()).toBe('All In One Rails')
  })

  it('renders the hero subtitle', () => {
    expect(wrapper.find('.hero-sub').exists()).toBe(true)
  })

  it('renders 6 tech stack cards', () => {
    expect(wrapper.findAll('.card').length).toBe(6)
  })

  it('renders all category names', () => {
    const labels = wrapper.findAll('.card-label').map(el => el.text())
    expect(labels).toEqual(['Backend', 'Frontend', 'Hotwire', 'Background & Queue', 'Infrastructure', 'Dev Tools'])
  })

  // ── Badges ──────────────────────────────────────────────────

  it('renders the Online badge', () => {
    const badges = wrapper.findAll('.badge')
    const texts = badges.map(b => b.text())
    expect(texts.some(t => t.includes('Online'))).toBe(true)
  })

  it('renders the Rails version badge', () => {
    const badges = wrapper.findAll('.badge')
    const texts = badges.map(b => b.text())
    expect(texts).toContain('Rails 8.1.3')
  })

  it('renders the Vue version badge', () => {
    const badges = wrapper.findAll('.badge')
    const texts = badges.map(b => b.text())
    expect(texts).toContain('Vue 3.5.38')
  })

  it('renders the ClickHouse disabled badge', () => {
    const badges = wrapper.findAll('.badge')
    const texts = badges.map(b => b.text())
    expect(texts.some(t => t.includes('ClickHouse'))).toBe(true)
  })

  // ── Versions ────────────────────────────────────────────────

  it('displays correct Rails version in cards', () => {
    expect(wrapper.text()).toContain('8.1.3')
  })

  it('displays correct Vue version in cards', () => {
    expect(wrapper.text()).toContain('3.5.38')
  })

  it('displays correct Vite version', () => {
    expect(wrapper.text()).toContain('8.0.16')
  })

  it('displays correct Solid Cable version', () => {
    expect(wrapper.text()).toContain('4.0.0')
  })

  it('displays mini_magick in Infrastructure card', () => {
    expect(wrapper.text()).toContain('mini_magick')
  })

  it('displays clickhouse-activerecord in Infrastructure card', () => {
    expect(wrapper.text()).toContain('clickhouse-activerecord')
  })

  it('displays Foreman in Dev Tools card', () => {
    expect(wrapper.text()).toContain('Foreman')
  })

  // ── Feature flag badge ───────────────────────────────────────

  it('renders FLAG badge for clickhouse-activerecord', () => {
    expect(wrapper.findAll('.item-flag').length).toBeGreaterThan(0)
  })

  // ── Stagger animation ────────────────────────────────────────

  it('cards start without card--visible class', () => {
    const freshWrapper = mount(DefaultHomePage)
    const visibleOnMount = freshWrapper.findAll('.card--visible').length
    expect(visibleOnMount).toBeLessThan(6)
  })

  it('all cards become visible after mount', async () => {
    await new Promise(resolve => setTimeout(resolve, 600))
    await nextTick()
    expect(wrapper.findAll('.card--visible').length).toBe(6)
  })

  // ── Footer ───────────────────────────────────────────────────

  it('renders 6 footer stats', () => {
    expect(wrapper.findAll('.footer-stat').length).toBe(6)
  })

  it('renders correct footer stat labels', () => {
    const labels = wrapper.findAll('.footer-label').map(el => el.text())
    expect(labels).toEqual(['RAILS', 'VUE', 'PG', 'TAILWIND', 'VITE', 'RUBY'])
  })

  it('renders developer credit in footer', () => {
    expect(wrapper.find('.footer-credit').text()).toContain('Muneeb Ahmad Farooqi')
  })
})
