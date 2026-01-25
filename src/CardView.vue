<script>
function shuffle_words(words) {
  // Sort words by score then frequency
  words.sort((a, b) => {
    if (a.score != b.score) return a.score - b.score
    return b.freq - a.freq
  })

  // Shuffle words locally
  const span = Math.ceil(Math.log(words.length))
  for (let i = 0; i < words.length - span; i++) {
    let j = Math.ceil(Math.random() * span)
    let tmp = words[i]
    words[i] = words[i + j]
    words[i + j] = tmp
  }

  return words
}


function compute_percentiles(words) {
  let i = 0;

  while (i < words.length) {
    let j = i + 1
    while (j < words.length && words[j].freq == words[i].freq) j++

    let p = ((j - i) * 0.5 + (words.length - j)) / words.length

    while (i < j) words[i++].percentile = p
  }
}


function word_percentile(word) {
  return Math.round(word.percentile * 1000) / 10 + '%'
}


export default {
  props: ['uid', 'tag'],
  name: 'CardView',


  data() {
    return {
      words:       [],
      word_data:   {},
      active:      0,
      front:      {index: 0, text: '', name: 'front', word: {}},
      back:       {index: 0, text: '', name: 'back',  word: {}},
      flip:        false,
      loading:     true,
      auto_speak:  false,
      timer:       undefined,
      prefer_back: false,
    }
  },


  computed: {
    word() {return this.words[this.active]},
    tags() {return (this.word_data[this.word] || {tags: []}).tags},
  },


  watch: {
    uid() {this.reload()},
    tag() {this.reload()}
  },


  activated() {this.reload()},


  methods: {
    async reload() {
      this.loading = true
      let url = '/api/user/tag/' + this.uid + '/' + this.tag
      this.words = await this.$api.get(url)
      compute_percentiles(this.words)
      if (1000 < this.words.length) this.words.length = 1000
      if (this.words.length) this.shuffle()
      this.loading = false
    },


    side_class(side) {
      let len  = (side.text || '').length
      let size = len < 24 ? 'reg' : (len < 48 ? 'small' : 'tiny')
      let max_word_len = side.text.split(' ').reduce(
        (max, w) => w.length < max.length ? max : w, '').length

      if (14 < max_word_len && size == 'reg') size = 'small'
      if (28 < max_word_len) size = 'tiny'

      return 'card-' + side.name + ' card-size-' + size
    },


    show_front() {
      this.front.index = this.active + 1
      let word         = this.words[this.active]
      this.front.word  = word
      this.front.title = 'Word (' + word_percentile(word) + ')'
      this.front.text  = word.word
      this.flip        = false
    },


    show_back() {
      this.back.index = this.active + 1
      let word        = this.words[this.active]
      this.back.word  = word
      this.back.title = 'Notes (' + word_percentile(word) + ')'
      this.back.text  = word.notes
      this.flip       = true
    },


    init() {
      if (this.prefer_back) this.show_back()
      else this.show_front()
      if (this.auto_speak) this.speak()
      this.stop()
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
      if (this.flip) this.show_front()
      else this.show_back()
      if (this.auto_speak) this.speak_card()
    },


    speak() {this.$util.tts(this.word.word)},


    speak_card() {
      if (this.flip) this.$util.tts(this.back.text, 'en')
      else this.$util.tts(this.front.text, 'fi')
    },


    play() {
      if (this.flip) {
        if (this.words.length - 1 <= this.active) {
          this.active = 0
          this.show_front()
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


    shuffle() {
      this.words = shuffle_words(this.words)
      this.active = 0
      this.init()
    },


    toggle_auto_speak() {
      this.auto_speak = !this.auto_speak
      if (this.auto_speak) this.speak()
    },


    toggle_side() {
      this.prefer_back = !this.prefer_back
      this.init()
    },


    async change_word_score(word, change) {
      let score = (word.score || 0) + change
      if (5 < score)  score =  5
      if (score < -5) score = -5

      if (score != word.score) {
        await this.$api.put('/api/words/' + word.word + '/score', {score})
        word.score = score
      }
    },


    async thumbs_up(word) {
      await this.change_word_score(word, 1)
      this.next()
    },


    async thumbs_down(word) {
      await this.change_word_score(word, -1)
      if (this.flip) this.next()
      else this.toggle()
    },
  }
}
</script>

<template lang="pug">
h3(v-if="loading") Loading...
h3(v-else-if="!words.length") Empty tag
.card-view(v-else)
  .card(@click="toggle", v-if="words.length",
    :class="{'card-flipped': flip}")
    .card-inner
      div(v-for="side in [front, back]", :class="side_class(side)")
        .card-header
          .card-title {{side.title}}
          .card-position {{side.index}} of {{words.length}}

        .card-main {{side.text}}

        .card-footer
          .button.fa.fa-refresh

          .card-rating(v-if="$user.name")
            .button.fa.fa-thumbs-down(
              @click.stop="thumbs_down(side.word)")
            .card-score {{side.word.score || '-'}}
            .button.fa.fa-thumbs-up(@click.stop="thumbs_up(side.word)")

          .button.fa.fa-headphones(@click.stop="speak_card")

  .actions
    .button.fa.fa-arrow-left(@click="prev")
    .button.fa.fa-random(@click="shuffle")
    .button.fa.fa-headphones(@click="toggle_auto_speak",
      :class="auto_speak ? 'active' : 'inactive'")
    .button.fa.fa-undo(@click="toggle_side",
      :class="prefer_back ? 'active' : 'inactive'")
    .button.fa(@click="start_stop", :class="'fa-' + (timer ? 'pause' : 'play')")
    router-link.button.fa.fa-link(:to="'/word/' + word.word", target="_blank")
    .button.fa.fa-arrow-right(@click="next")
</template>

<style lang="stylus">
.card-view
  display flex
  flex-direction column
  align-items center
  gap 1em
  margin 10% auto

  .word-tags
    justify-content right

  .card, .actions
    width 415px
    max-width calc(100vw - 25px)

  .card
    display flex
    flex-direction column
    cursor pointer
    text-align center
    background-color transparent
    perspective 1000px
    height calc(415px / 1.618)

    &.card-flipped .card-inner
      transform rotateY(180deg)

    .card-inner
      position relative
      width 100%
      height 100%
      display flex
      text-align center
      transition transform 0.6s
      transform-style preserve-3d
      border-radius 6px
      box-shadow 0 4px 8px 0 rgba(0,0,0,0.2)

    .card-main
      flex 1
      font-size 36pt
      padding 0.5em 0

    .card-front, .card-back
      position absolute
      display flex
      flex-direction column
      width calc(100% - 1em)
      height calc(100% - 1em)
      padding 0.5em
      backface-visibility hidden
      border-radius 6px
      overflow hidden

      &.card-size-small > .card-main
        font-size 24pt

      &.card-size-tiny > .card-main
        font-size 18pt

    .card-front
      background-color #a2d1f3

    .card-back
      background-color #73d9cd
      transform rotateY(180deg)

    .card-header, .card-footer
      display flex
      justify-content space-between
      align-items center

      .fa
        font-size 16pt

    .card-footer
      font-size 16pt

    .card-rating
      display flex
      gap 0.5em

      .card-score
        width 1.5em
        text-align center

  .actions
    display flex
    justify-content space-between
    font-size 30pt

    .button
      padding 0

    .fa.active
      color gold
</style>