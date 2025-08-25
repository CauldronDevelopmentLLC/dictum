<script>
function shuffle(array) {
  for (let i = array.length; i; i--) {
    let r = Math.floor(Math.random() * i)
    let t = array[i - 1]
    array[i - 1] = array[r]
    array[r] = t
  }

  return array
}


export default {
  props: ['uid', 'tag'],
  name: 'CardView',


  data() {
    return {
      words:      [],
      active:     0,
      flip:       false,
      loading:    true,
      auto_speak: false,
      timer:      undefined,
    }
  },


  computed: {
    word() {return this.words[this.active]}
  },


  async activated() {
    this.loading = true
    let url = '/api/user/card/' + this.uid + '/' + this.tag
    this.words = await this.$api.get(url)
    this.shuffle()
    this.loading = false
  },


  methods: {
    init() {
      this.flip = false
      if (this.auto_speak) this.speak()
      this.stop()
    },


    speak() {this.$util.tts(this.word.word)},


    speak_card() {
      if (this.flip) this.$util.tts(this.word.notes, 'en')
      else this.$util.tts(this.word.word, 'fi')
    },


    play() {
      if (this.flip) {
        if (this.words.length - 1 <= this.active) {
          this.active = 0
          this.flip = false
          return
        }

        this.next()

      } else this.toggle()

      this.timer = setTimeout(() => this.play(), 4000)
    },


    start() {
      this.init()
      this.timer = setTimeout(() => this.play(), 4000)
    },


    stop() {
      clearTimeout(this.timer)
      this.timer = undefined
    },


    start_stop() {
      if (this.timer != undefined) this.stop()
      else this.start()
    },


    next() {
      this.active++
      if (this.words.length <= this.active) this.active = 0
      this.init()
    },


    prev() {
      this.active--
      if (this.active < 0) this.active = this.words.length - 1
      this.init()
    },


    toggle() {
      this.flip = !this.flip
      if (this.auto_speak) this.speak_card()
    },


    shuffle() {
      shuffle(this.words)
      this.active = 0
      this.init()
    },


    toggle_auto_speak() {
      this.auto_speak = !this.auto_speak
      if (this.auto_speak) this.speak()
    },
  }
}
</script>

<template lang="pug">
h3(v-if="loading") Loading...
.card-view(v-else)
  .card(@click="toggle", v-if="words.length",
    :class="'card-' + (flip ? 'back' : 'front')")
    .card-header
      .card-title {{flip ? 'Notes' : 'Word'}}
      .card-position {{active + 1}} of {{words.length}}

    .card-main
      .card-word(v-if="!flip") {{word.word}}
      .card-notes(v-else) {{word.notes}}

    .card-footer
      .button.fa.fa-refresh
      .button.fa.fa-headphones(@click.stop="speak_card")

  .actions
    .button.fa.fa-arrow-left(@click="prev")
    .button.fa.fa-random(@click="shuffle")
    .button.fa.fa-headphones(@click="toggle_auto_speak",
      :class="auto_speak ? 'active' : 'inactive'")
    .button.fa(@click="start_stop", :class="'fa-' + (timer ? 'pause' : 'play')")
    router-link.button.fa.fa-link(:to="'/word/' + word.word", target="_blank")
    .button.fa.fa-arrow-right(@click="next")
</template>

<style lang="stylus">
.card-view
  margin 10% auto

  .card
    display flex
    flex-direction column
    width 30em
    max-width calc(100vw - 2em)
    height calc(30em / 1.618)
    border-radius 6px
    padding 0.5em
    cursor pointer
    text-align center

    .card-header, .card-footer
      display flex
      justify-content space-between

      .fa
        font-size 16pt

    &.card-front
      background-color #a2d1f3

    &.card-back
      background-color #73d9cd

    .card-main
      flex 1
      font-size 36pt
      padding 0.5em 0

   .actions
     display flex
     justify-content space-between
     font-size 30pt

     .fa.active
       color gold
</style>