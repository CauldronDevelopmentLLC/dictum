import {createRouter, createWebHashHistory} from 'vue-router'
import DictView from './DictView.vue'
import WordView from './WordView.vue'
import TagView  from './TagView.vue'


export default createRouter({
  history: createWebHashHistory(),
  routes: [
    {path: '/', component: DictView},
    {path: '/word/:word', component: WordView, props: true},
    {path: '/tag/:name',  component: TagView,  props: true},
  ]
})
