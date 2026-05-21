import { defineStore } from 'pinia'

export const useAppStore = defineStore('app', {
  state: () => ({
    name: 'All In One Rails',
    version: '1.0.0',
  }),
  getters: {
    title: (state) => `${state.name} v${state.version}`,
  },
})
