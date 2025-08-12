<script>
function word_cmp(a, b) {
  return a.word.toLowerCase().localeCompare(b.word.toLowerCase(), 'fi')
}


export default {
  name: 'IndexView',
  props: ['words'],


  data() {
    return {
      width: document.body.offsetWidth
    }
  },


  computed: {
    split() {return Math.max(1, Math.floor(this.width / 400))},


    entries() {
      let l = []
      let last
      this.words.sort(word_cmp)

      for (let e of this.words) {
        let letter = e.word.at(0).toUpperCase()

        if (letter != last) {
          l.push(letter)
          last = letter
        }

        l.push(e)
      }

      if (l.length < 4) return [l]

      const part = Math.ceil(l.length / this.split)
      let parts = []
      for (let i = 0; i < this.split; i++)
        parts.push(l.slice(i * part, (i + 1) * part))

      return parts
    }
  },


  mounted()   {window.addEventListener   ('resize', this.on_resize)},
  unmounted() {window.removeEventListener('resize', this.on_resize)},


  methods: {
    on_resize() {this.width = document.body.offsetWidth},
  }
}
</script>

<template lang="pug">
.index-view
  .index-columns
    .index-column(v-for="column in entries")
      .index-entry(v-for="entry in column")
        router-link.index-word(v-if="typeof entry == 'object'",
          :to="'/word/' + entry.word")
          .index-entry-word {{entry.word}}
          .index-entry-notes {{entry.notes}}

        template(v-else)
          .index-letter(v-if="2 < words.length") {{entry}}
</template>

<style lang="stylus">
.index-view
  .index-columns
    display flex
    gap 2em

  .index-column
    flex 1
    display flex
    flex-direction column
    gap 0.25em

    .index-entry
      display flex
      flex-direction row
      gap 0.5em

      .index-letter
        margin-top 0.5em
        font-weight bold
        font-size 120%

      .index-word
        display flex
        gap 1em
        flex 1
        text-decoration none
        cursor pointer
        color #000
        background #f7f7f7

        &:hover
          background #f1f1f1

        .index-entry-word
          flex-shrink 0
          width 10em
          font-style italic
          font-weight bold
</style>
