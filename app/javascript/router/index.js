import { createRouter, createWebHistory } from 'vue-router'
import DefaultHomePage from '../components/DefaultHomePage.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: DefaultHomePage,
  },
]

export default createRouter({
  history: createWebHistory(),
  routes,
})
