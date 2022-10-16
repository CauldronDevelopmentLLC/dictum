import {createRouter, createWebHistory} from 'vue-router'
import DictView from './DictView.vue'
import WordView from './WordView.vue'
import util from './util.js'


export default createRouter({
  history: createWebHistory(),
  routes: [
    {path: '/', component: DictView},
    {
      path: '/word',
      component: WordView,
      props: route => ({word: route.query.word})
    },
  ]
})
