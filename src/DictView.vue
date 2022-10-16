<script>
import util from './util.js'
import ConfirmDialog from './ConfirmDialog.vue'

export default {
  name: 'DictView',
  components: {ConfirmDialog},


  data() {
    return {
      dict: [],
      search: '',
      new_word: '',
      new_desc: '',
      width: document.body.offsetWidth
    }
  },


  computed: {
    letters() {
      let l = []
      let last

      for (let e of this.dict) {
        let letter = e.word.at(0).toUpperCase()
        if (letter != last) l.push(letter)
        last = letter
      }

      return l
    },


    words() {
      let d = {}
      for (let e of this.dict) d[e.word] = true
      return d
    },


    split() {return Math.max(1, Math.floor(this.width / 450))},


    entries() {
      let l = []
      let last
      let re = new RegExp(this.search, 'i')

      for (let e of this.dict) {
        if (this.search && !re.test(e.word) && !re.test(e.description))
          continue

        let letter = e.word.at(0).toUpperCase()

        if (letter != last) {
          l.push(letter)
          last = letter
        }

        l.push(e)
      }

      if (l.length < 32) return [l]

      const part = Math.ceil(l.length / this.split)
      let parts = []
      for (let i = 0; i < this.split; i++)
        parts.push(l.slice(i * part, (i + 1) * part))

      return parts
    }
  },


  mounted() {
    this.update()
    window.addEventListener('resize', this.on_resize)
  },


  unmounted() {
    window.removeEventListener('resize', this.on_resize)
  },


  methods: {
    on_resize() {this.width = document.body.offsetWidth},


    update() {
      util.api('GET', '/api/dict').then(dict => this.dict = dict)
        .then(() => {
          this.new_word = this.new_desc = ''
          this.$refs.word.focus()
        })
    },


    fi_input(name) {
      this[name] = this[name].replace(/;/g, 'ö').replace(/'/g, 'ä')
    },


    search_input(e) {
      this.search = e.target.value.replace(/;/g, 'ö').replace(/'/g, 'ä')
    },


    _add_word() {
      util.api('PUT', '/api/dict/word/' + this.new_word,
              {description: this.new_desc}).then(this.update)
    },


    add_word() {
      if (this.new_word in this.words) {
        let msg = 'Overwrite ' + this.new_word + '?'

        this.$refs.confirmDialog.open(msg, ok => {
          if (ok) this._add_word()
        })

      } else this._add_word()
    },


    save_word(entry) {
      util.api('PUT', '/api/dict/word/' + entry.word,
              {description: entry.description})
        .then(() => {entry.edit = false})
    },


    _del_word(word) {
      util.api('DELETE', '/api/dict/word/' + word).then(this.update)
    },


    del_word(word) {
      this.$refs.confirmDialog.open('Delete ' + word + '?', ok => {
        if (ok) this._del_word(word)
      })
    },

    dict_url(word) {
      return 'https://en.wiktionary.org/wiki/' + word + '#Finnish'
    }
  }
}
</script>

<template lang="pug">
.dict-view
  .dict-header
    .count {{dict.length}} Words

    .letters
      a(v-for="letter in letters", :href="'#letter-' + letter") {{letter}}

    .actions
      .new-entry
        label New
        input.entry-word(ref="word", form="new-word-form", v-model="new_word",
          @input="fi_input('new_word')")
        input.entry-description(form="new-word-form", v-model="new_desc")
        button(form="new-word-form", type="submit"): .fa.fa-plus
        form#new-word-form(@submit.prevent="add_word")

      .search
        label Search
        input(:value="search", @input="search_input")

  .dict-body
    .entries(v-for="column in entries")
      .entry(v-for="entry in column", :class="entry.word ? 'word-entry' : ''")
        template(v-if="typeof entry == 'object'")
          .entry-word {{entry.word}}
          .entry-description
            span(v-if="!entry.edit") {{entry.description}}
            input(v-else, v-model="entry.description")
          .actions
            button(v-if="!entry.edit", @click="entry.edit = true"): .fa.fa-edit
            button(v-else, @click="save_word(entry)"): .fa.fa-save
            a(:href="dict_url(entry.word)", target="_blank")
              button: .fa.fa-link
            button(@click="del_word(entry.word)"): .fa.fa-trash
        template(v-else)
          .entry-letter(:id="'letter-' + entry") {{entry}}

  ConfirmDialog(ref="confirmDialog")
</template>

<style lang="stylus">
.dict-view
  display flex
  flex-direction column
  gap 0.5em

  .dict-header
    display flex
    flex-direction column
    gap 0.5em

    .entry-description
      flex 1

    .count
      font-size 110%
      text-align center

    .letters
      display flex
      gap 0.5em

      a
        flex 1
        text-align center
        text-decoration none

    .actions
      display flex
      flex-direction row
      flex-wrap wrap
      gap 0.5em

      > *
        flex 1
        display flex
        gap 0.25em
        flex-wrap wrap

        input
          flex 1

        .entry-word
          flex 0

  .dict-body
    display flex
    gap 2em

    .entries
      flex 1
      display flex
      flex-direction column
      gap 0.25em

      .entry
        display flex
        flex-direction row
        gap 0.5em

        &.word-entry
          background #f7f7f7

        > :first-child
          width 10em

        .entry-letter
          margin-top 0.5em
          font-weight bold
          font-size 120%

        .entry-word
          font-style italic
          font-weight bold
          padding-right 1em

        .entry-description
          flex 1

          input
            width calc(100% - 1em)

        .actions
          display flex
          gap 0.25em
          align-items flex-start
</style>
