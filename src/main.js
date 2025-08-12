import {createApp} from 'vue'
import router    from './router'
import util      from './util.js'
import API       from './api.js'
import App       from './App.vue'
import Dialog    from './Dialog.vue'
import IndexView from './IndexView.vue'


async function main() {
  const app = createApp(App)
  const ctx = app.config.globalProperties
  ctx.$util = util
  ctx.$api  = new API(ctx)
  ctx.$user = await ctx.$api.login(true) || {}

  app.use(router)
  app.component('Dialog',    Dialog)
  app.component('IndexView', IndexView)
  app.mount('#app')
}

main()