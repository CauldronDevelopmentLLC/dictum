<script>
export default {
  props: ['word', 'tags'],
  name: 'WordTags',


  computed: {
    user_tags() {return ['star'].concat(this.$root.user_tags)}
  },


  methods: {
    async toggle_tag(tag) {
      let i = this.tags.indexOf(tag)
      if (i == -1) {
        await this.$api.put('/api/words/' + this.word + '/tags/' + tag)
        this.tags.push(tag)

      } else {
        await this.$api.delete('/api/words/' + this.word + '/tags/' + tag)
        this.tags.splice(i, 1)
      }
    },


    has_tag(tag) {return this.tags.indexOf(tag) != -1},


    tag_classes(tag) {
      return 'fa-' + tag + ' ' + (this.has_tag(tag) ? 'active' : 'inactive')
    }
  }
}
</script>

<template lang="pug">
.word-tags(v-if="$user.name")
  .word-tag.fa(v-for="tag in user_tags", :class="tag_classes(tag)",
    @click="toggle_tag(tag)", :title="'Toggle ' + tag + ' tag'")
</template>

<style lang="stylus">
.word-tags
  display flex
  gap 0.5em
  padding-right 0.25em
</style>