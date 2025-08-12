<script>
export default {
  name: 'DictView',
  props: ['search'],


  data() {
    return {
      tags: [],
      words: [],
      active_tag: 'all',
    }
  },


  watch: {
    '$user.name'() {this.active_tag = 'star'},
    active_tag() {this.update()}
  },


  computed: {
    matches() {
      let re = new RegExp(this.search, 'i')
      return this.words.filter(e =>
        !this.search || re.test(e.word) || re.test(e.notes))
    }
  },


  mounted() {
    if (this.$user.name) this.active_tag = 'star'
    if (!this.words.length) this.update()
  },


  methods: {
    async update() {
      let params
      if (this.active_tag != 'all') params = 'tags=' + this.active_tag
      this.words = await this.$api.get('/api/words', params)
      this.tags  = await this.$api.get('/api/tags')
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
  select(v-model="active_tag")
    option(value="all") all
    option(v-for="tag in tags", :value="tag.name")
      | {{pluralize(tag.name)}} ({{format_count(tag.count)}})


  template(v-if="matches && matches.length")
    .word-count(v-if="this.search")
      | {{matches.length.toLocaleString()}}
      | {{active_tag == 'all' ? '' : active_tag}}
      | {{pluralize('match', matches.length)}}

    .word-count(v-else)
      | {{matches.length.toLocaleString()}}
      | {{pluralize(active_tag == 'all' ? 'word' : active_tag, matches.length)}}

  section: IndexView(:words="matches")
</template>

<style lang="stylus">
.dict-view
  display flex
  flex-direction column
  gap 0.5em
  min-width 20em

  .word-count
    font-weight bold
</style>
