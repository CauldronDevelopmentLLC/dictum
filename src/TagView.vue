<script>
export default {
  props: ['name'],


  data() {
    return {
      words: []
    }
  },


  beforeRouteEnter(to, from, next) {
    this.load_tag(to.params.name, words => next(vm => {vm.words = words || []}))
  },


  beforeRouteUpdate(to, from) {
    this.load_tag(to.params.name, words => {this.words = words || []})
  },


  methods() {
    async function load_tag(tags, next) {
      next(await this.$api.get('/api/words', {tags}))
    }
  }
}
</script>

<template lang="pug">
.tag-view
  h1.tag-title {{name}} ({{words.length.toLocaleString()}})

  .tag-words: IndexView(:words="words")
</template>

<style lang="stylus">
.tag-view
  max-width 60em
  padding 0 1em
</style>
