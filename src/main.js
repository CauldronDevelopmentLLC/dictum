import {createApp} from 'vue'
import App    from './App.vue'
import Dialog from './Dialog.vue'
import router from './router'

const app = createApp(App);
app.component('Dialog', Dialog)
app.use(router)
app.mount('#app');
