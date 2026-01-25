<script>
export default {
  name: 'DictView',
  props: ['search'],


  data() {
    return {
      loading:    true,
      tags:       [],
      words:      [],
      active_tag: 'verb',
    }
  },


  watch: {
    '$user.name'() {this.active_tag = 'star'},
    active_tag() {this.update()}
  },


  computed: {
    matches() {
      let re = new RegExp(this.search.trim(), 'i')
      return this.words.filter(e =>
        !this.search.trim() || re.test(e.word) || re.test(e.notes))
    }
  },


  mounted() {
    if (this.$user.name) this.active_tag = 'star'
    if (!this.words.length) this.update()
  },


  methods: {
    async update() {
      this.loading = true
      this.words   = await this.$api.get('/api/tag/' + this.active_tag)
      this.tags    = await this.$api.get('/api/tags')
      this.loading = false
    },


    format_count(count) {
      return count < 1000 ? count : ((count / 1000).toFixed(1) + 'k')
    },


    pluralize(word, count = 2) {
      let s = /.*((s)|(sh)|(ch)|(x)|(z))$/.test(word) ? 'es' : 's'
      return word + (count == 1 ? '' : s)
    }
  }
}
</script>

<template lang="pug">
.dict-view(@keyup.esc="reset()")
  h2(v-if="loading") Loading...
  template(v-else)
    select(v-model="active_tag")
      option(v-for="tag in tags", :value="tag.name")
        | {{pluralize(tag.name)}} ({{format_count(tag.count)}})

    template(v-if="matches && matches.length")
      .word-count(v-if="this.search")
        | {{matches.length.toLocaleString()}}
        | {{active_tag}}
        | {{pluralize('match', matches.length)}}

      .word-count(v-else)
        | {{matches.length.toLocaleString()}}
        | {{pluralize(active_tag, matches.length)}}

    section: IndexView(:words="matches")
</template>

<style lang="stylus">
.dict-view
  display flex
  flex-direction column
  gap 0.5em
  min-width 20em

  > h2
    margin 0

  .word-count
    font-weight bold
</style>
