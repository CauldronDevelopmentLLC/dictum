import {createRouter, createWebHashHistory} from 'vue-router'
import DictView    from './DictView.vue'
import HistoryView from './HistoryView.vue'
import TagsView    from './TagsView.vue'
import AccountView from './AccountView.vue'
import WordView    from './WordView.vue'
import CardView    from './CardView.vue'


export default createRouter({
  history: createWebHashHistory(),
  routes: [
    {path: '/',           component: DictView},
    {path: '/account',    component: AccountView},
    {path: '/history',    component: HistoryView},
    {path: '/tags',       component: TagsView},
    {path: '/word/:word', component: WordView, props: true},
    {path: '/user/card/:uid/:tag', component: CardView, props: true},
  ]
})
