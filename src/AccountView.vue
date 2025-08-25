<script>
import HistoryView from './HistoryView.vue'

let tags = ['adjust', 'asterisk', 'bath', 'bell', 'bicycle', 'binoculars',
  'bomb', 'book', 'bookmark', 'bug', 'bullseye', 'camera', 'car',
  'certificate', 'circle', 'cloud', 'cube', 'cutlery', 'diamond', 'eye',
  'fighter-jet', 'flag', 'flash', 'gift', 'glass', 'globe', 'heart', 'leaf',
  'legal', 'magnet', 'map', 'music', 'paper-plane', 'plane', 'plug',
  'puzzle-piece', 'road', 'rocket', 'shield', 'ship', 'shopping-basket',
  'square', 'suitcase', 'tag', 'thumbs-down', 'thumbs-up', 'ticket', 'tint',
  'train', 'tree', 'trophy', 'truck', 'umbrella', 'university', 'user-secret',
  'wrench']


export default {
  name: 'AccountView',
  components: {HistoryView},


  data() {
    return {
      all_tags: tags,
    }
  },


  methods: {
    tag_is_active(tag) {return this.$root.user_tags.indexOf(tag) != -1},


    async toggle_tag(tag) {
      let i = this.$root.user_tags.indexOf(tag)

      if (i == -1) {
        await this.$api.put('/api/user/tags/' + tag)
        this.$root.user_tags.push(tag)

      } else {
        await this.$api.delete('/api/user/tags/' + tag)
        this.$root.user_tags.splice(i, 1)
      }
    },


    get_tag_classes(tag) {
      return 'fa-' + tag + ' ' +
        (this.tag_is_active(tag) ? 'active' : 'inactive')
    }
  }
}
</script>

<template lang="pug">
.account-view
  section
    h2 Tags
    .user-tags
      .word-tag.fa(v-for="tag in all_tags", :class="get_tag_classes(tag)",
        :title="tag", @click="toggle_tag(tag)")

  section
    h2 History
    history-view
</template>

<style lang="stylus">
.account-view
  display flex
  flex-direction column
  gap 1em

  > section > h2
    margin-top 0

  .user-tags
    display flex
    gap 1em
    flex-wrap wrap

    select, option
      font-family FontAwesome

    label
      display inline-flex
      gap 0.25em
      align-items center
</style>