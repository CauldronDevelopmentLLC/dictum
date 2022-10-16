<script>
import util from './util.js'
import {marked} from 'marked'


export default {
  name: 'WordView',
  props: ['word'],


  data() {
    return {
      edit: false,
      desc: ''
    }
  },


  computed: {
    description() {return marked.parse(this.desc)}
  },


  mounted() {this.update()},


  methods: {
    update() {
      util.api('GET', '/api/dict/word/' + this.word)
        .then(data => {
          this.desc = data.description
          this.edit = !this.desc
        })
    },


    save() {
      util.api('PUT', '/api/dict/word/' + this.word, {description: this.desc})
        .then(() => {
          this.edit = false
        })
    }
  }
}
</script>

<template lang="pug">
.word-view
  .word-header
    h1 {{word}}
    button(v-if="edit", form="save-form", type="submit"): .fa.fa-save
    button(v-else, @click="this.edit = true"): .fa.fa-edit

  .word-body
    p(v-if="!edit", v-html="description")
    textarea(v-else, form="save-form", v-model="desc")

  form#save-form(@submit.prevent="save")

</template>

<style lang="stylus">
.word-view
  display flex
  flex-direction column

  .word-header
    display flex
    align-items center
    gap 1em

  .word-body
    textarea
      width calc(100% - 2em)
      height calc(100vh - 10em)
</style>
