import '@hotwired/turbo-rails'
import '../styles/application.css'
import { Application } from '@hotwired/stimulus'
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from '../App.vue'
import router from '../router'

const stimulus = Application.start()
stimulus.debug = false

const app = createApp(App)
app.use(createPinia())
app.use(router)
app.mount('#all_in_one_rails')
