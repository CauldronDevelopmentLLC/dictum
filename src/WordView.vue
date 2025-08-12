<script>
import Inflections from './Inflections.vue'


const inflections = {
  'nom_sg':         'nominative singular',
  'gen_sg':         'genitive singular',
  'par_sg':         'partitive singular',
  'ine_sg':         'inessive singular',
  'ela_sg':         'elative singular',
  'ill_sg':         'illative singular',
  'ade_sg':         'adessive singular',
  'abl_sg':         'ablative singular',
  'all_sg':         'allative singular',
  'ess_sg':         'essive singular',
  'tra_sg':         'translative singular',
  'ins_sg':         'instructive singular',
  'abe_sg':         'abessive singular',
  'nom_pl':         'nominative plural',
  'gen_pl':         'genitive plural',
  'par_pl':         'partitive plural',
  'ine_pl':         'inessive plural',
  'ela_pl':         'elative plural',
  'ill_pl':         'illative plural',
  'ade_pl':         'adessive plural',
  'abl_pl':         'ablative plural',
  'all_pl':         'allative plural',
  'ess_pl':         'essive plural',
  'tra_pl':         'translative plural',
  'ins_pl':         'instructive plural',
  'abe_pl':         'abessive plural',
  'cmt':            'comitative plural',

  'acc_nom_sg':     'accusative nominative singular',
  'acc_nom_pl':     'accusative nominative plural',
  'acc_gen_sg':     'accusative genitive singular',
  'acc_gen_pl':     'accusative genitive plural',
  'acc_sg':         'accusative singular',
  'acc_pl':         'accusative plural',

  'pos_1sg':        'possessive first-person singular',
  'pos_2sg':        'possessive second-person singular',
  'pos_3':          'possessive third-person',
  'pos_1pl':        'possessive first-person plural',
  'pos_2pl':        'possessive second-person plural',

  'comp':           'comparative',
  'sup':            'superlative',

  'sss_sg':         'superessive singular',
  'del_sg':         'delative singular',
  'sub_sg':         'sublative singular',
  'lat_sg':         'lative singular',
  'tmp_sg':         'temporal singular',
  'cau_sg':         'causative singular',
  'mul_sg':         'multiplicative singular',
  'dis_sg':         'distributive singular',
  'tdt_sg':         'temporal distributive singular',
  'pro_sg':         'prolative singular',
  'sit_sg':         'situative singular',
  'opp_sg':         'oppositive singular',
  'sss_pl':         'superessive plural',
  'del_pl':         'delative plural',
  'sub_pl':         'sublative plural',
  'lat_pl':         'lative plural',
  'tmp_pl':         'temporal plural',
  'cau_pl':         'causative plural',
  'mul_pl':         'multiplicative plural',
  'dis_pl':         'distributive plural',
  'tdt_pl':         'temporal distributive plural',
  'pro_pl':         'prolative plural',
  'sit_pl':         'situative plural',
  'opp_pl':         'oppositive plural',

  'sep':            'separative',
  'loc':            'locative',

  'pres_1sg':       'present first-person singular',
  'pres_2sg':       'present second-person singular',
  'pres_3sg':       'present third-person singular',
  'pres_1pl':       'present first-person plural',
  'pres_2pl':       'present second-person plural',
  'pres_3pl':       'present third-person plural',
  'pres_pasv':      'present passive',
  'past_1sg':       'past first-person singular',
  'past_2sg':       'past second-person singular',
  'past_3sg':       'past third-person singular',
  'past_1pl':       'past first-person plural',
  'past_2pl':       'past second-person plural',
  'past_3pl':       'past third-person plural',
  'past_pasv':      'past passive',
  'impr_2sg':       'present imperative second-person singular',
  'impr_3sg':       'present imperative third-person singular',
  'impr_1pl':       'present imperative first-person plural',
  'impr_2pl':       'present imperative second-person plural',
  'impr_3pl':       'present imperative third-person plural',
  'impr_pasv':      'present imperative passive',
  'cond_1sg':       'present conditional first-person singular',
  'cond_2sg':       'present conditional second-person singular',
  'cond_3sg':       'present conditional third-person singular',
  'cond_1pl':       'present conditional first-person plural',
  'cond_2pl':       'present conditional second-person plural',
  'cond_3pl':       'present conditional third-person plural',
  'cond_pasv':      'present conditional passive',
  'potn_1sg':       'present potential first-person singular',
  'potn_2sg':       'present potential second-person singular',
  'potn_3sg':       'present potential third-person singular',
  'potn_1pl':       'present potential first-person plural',
  'potn_2pl':       'present potential second-person plural',
  'potn_3pl':       'present potential third-person plural',
  'potn_pasv':      'present potential passive',

  'pres_conn':      'present connegative',
  'pres_pasv_conn': 'present passive connegative',
  'cond_conn':      'conditional connegative',
  'cond_pasv_conn': 'conditional passive connegative',
  'impr_conn':      'imperative connegative',
  'impr_pasv_conn': 'imperative passive connegative',
  'potn_conn':      'potential connegative',
  'potn_pasv_conn': 'potential passive connegative',

  'pres_part':      'present active participle',
  'pres_pasv_part': 'present passive participle',
  'past_part':      'past active participle',
  'past_part_pl':   'past plural active participle',
  'past_pasv_part': 'past passive participle',
  'agnt_part':      'agent participle',
  'nega_part':      'negative participle',

  'inf1':           'infinitive-i',
  'inf1_long':      'infinitive-i-long',
  'inf2_ine':       'active infinitive-ii inessive',
  'inf2_ins':       'active infinitive-ii instructive',
  'inf2_pasv_ine':  'passive infinitive-ii inessive',
  'inf3_ine':       'active infinitive-iii inessive',
  'inf3_ela':       'active infinitive-iii elative',
  'inf3_ill':       'active infinitive-iii illative',
  'inf3_ade':       'active infinitive-iii adessive',
  'inf3_abe':       'active infinitive-iii abessive',
  'inf3_ins':       'active infinitive-iii instructive',
  'inf3_pasv_ins':  'passive infinitive-iii instructive',
  'inf4_nom':       'infinitive-iv nominative',
  'inf4_par':       'infinitive-iv partitive',
  'inf5':           'infinitive-v',
}


let pos_names = {
  'adj':   'adjective',
  'pron':  'pronoun',
  'postp': 'postposition',
  'intj':  'interjection',
  'conj':  'conjunction',
  'adv':   'adverb',
  'det':   'determiner',
  'prep':  'preposition',
  'num':   'number',
}


function word_not_found(word, next) {
  next({word, error: 'Word not found.'})
}


function filter_word(word) {
  return word.toLowerCase().replace(/[^\wáâåäéóöõšșüž ]/g, '')
}


function get_group(word) {
  if (word.length < 4) return word[0]
  return word.substr(0, 4).replaceAll(' ', '_')
}


function get_map(word, next) {
  fetch('map/' + get_group(word) + '.json.gz')
    .then(r => {
      if (r.ok) return r.json()
      else next()

    }).then(data => {if (data) next(data[word])})
}


function get_word(word, next) {
  word = filter_word(word)

  get_map(word, roots => {
    fetch('comp/' + get_group(word) + '.json.gz')
      .then(r => {if (r.ok) return r.json()})
      .then(data => {
        if (data && data[word]) {
          data = data[word]

          if (roots) {
            roots = roots.filter(root => root[0] != word)
            if (roots) data.roots = roots
          }

          return next(data)

        }

        if (roots) next({word, roots})
        else word_not_found(word, next)

      }).then(() => {window.scrollTo(0, 0)})
  })
}


function load_word(word, next) {
  fetch('/api/words/' + filter_word(word))
    .then(r => r.json())
    .then(user_info => {
      get_word(word, data => {
        if (user_info.error && !data.error) user_info = undefined
        next(Object.assign(user_info || {tags: []}, data || {}))
      })
    })
}


function apply(self, data) {
  data.tags = data.tags || []
  self.data = data
  self.definition = 0
  self.orig_notes = data.notes

  // Preselect correct word form
  if (data.defs)
    for (let i = 0; i < data.defs.length; i++)
      if (data.defs[i].word == self.word) {
        self.definition = i
        break
      }

  if (!data.error) self.$root.clear()
}


export default {
  props: ['word'],
  components: {Inflections},


  data() {
    return {
      lang: localStorage.getItem('dictum-lang') || 'en',
      data: {tags: []},
      definition: 0,
      def_pos: undefined,
      orig_notes: ''
    }
  },


  watch: {
    lang() {localStorage.setItem('dictum-lang', this.lang)},


    defs() {
      if (!this.defs.length) return
      if (this.defs.length <= this.definition) this.definition = 0
      let pos = this.defs[this.definition].pos

      // Select new definition with same POS, if it exists
      if (this.def_pos && pos != this.def_pos)
        for (let i = 0; i < this.defs.length; i++)
          if (this.defs[i].pos == this.def_pos) {
            this.definition = i
            break
          }

      this.def_pos = this.defs[this.definition].pos
    }
  },


  computed: {
    starred() {return this.data.tags.indexOf('star') != -1},

    roots() {
      if (!(this.data.roots || []).length) return

      let roots = {}
      for (let root of this.data.roots) {
        if (!roots[root[1]]) roots[root[1]] = {}
        roots[root[1]][root[0]] = true
      }

      let forms = []
      for (let form in roots) {
        let words = Object.keys(roots[form])
        words = this.$util.link_text('[[' + words.join(']], [[') + ']]')
        if (!inflections[form]) console.debug(form)
        form = inflections[form]
        forms.push(form + ' of ' + words)
      }

      return forms
    },


    defs() {
      let defs = []

      for (let def of (this.data.defs || []))
        if ((this.lang == 'en' && def.lang == 'Finnish') ||
            (this.lang == 'fi' && def.lang == 'Suomi'))
          defs.push(def)

      return defs
    }
  },


  beforeRouteEnter(to, from, next) {
    load_word(to.params.word, data => next(vm => apply(vm, data)))
  },


  beforeRouteUpdate(to, from) {
    load_word(to.params.word, data => apply(this, data))
  },


  methods: {
    tts(text) {this.$util.tts(text)},
    get_pos(pos) {return pos_names[pos] || pos},
    link_text(text) {return this.$util.link_text(text)},


    async toggle_star() {
      let i = this.data.tags.indexOf('star')
      if (i == -1) {
        await this.$api.put('/api/words/' + this.word + '/tags/star')
        this.data.tags.push('star')

      } else {
        await this.$api.delete('/api/words/' + this.word + '/tags/star')
        this.data.tags.splice(i, 1)
      }
    },


    async save_notes() {
      if (!this.data.notes) await this.delete_notes()
      else {
        await this.$api.put('/api/words/' + this.word + '/notes',
                      {notes: this.data.notes})
        this.orig_notes = this.data.notes
        if (!this.starred) await this.toggle_star()
      }
    },


    async delete_notes() {
      await this.$api.delete('/api/words/' + this.word + '/notes')
      this.data.notes = this.orig_notes = ''
    }
  }
}
</script>

<template lang="pug">
.word-view
  h1.word-title
    select(v-model="lang")
      option(value="en") EN
      option(value="fi") FI

    span(v-if="!defs.length") {{data.word}}
    span(v-else-if="defs.length == 1")
      | {{defs[0].word}} ({{get_pos(defs[0].pos)}})

    select(v-else, v-model="definition")
      option(v-for="(d, index) in defs", :value="index")
        | {{d.word}} ({{get_pos(d.pos)}})

    .audio.fa.fa-headphones(@click="tts(data.word)")

    template(v-if="$user.name")
      .fa.fa-star(:class="{star: data.tags.indexOf('star') != -1}",
        v-if="(defs || []).length", @click="toggle_star")

      .word-notes(v-if="!data.error")
        form(@submit.prevent="save_notes")
          input(v-model="data.notes", @keyup.enter="save_notes"
            autocorrect="off" autocapitalize="none", placeholder="Enter notes")
          button(@click.prevent="delete_notes", title="Delete notes.",
            type="button")
            .fa.fa-trash
          button.save(type="submit", title="Save notes.",
            :disabled="orig_notes == data.notes"): .fa.fa-save

  h2.word-error(v-if="data.error") {{data.error}}

  .word-root(v-if="roots", v-for="root in roots", v-html="root")

  .word-def(v-if="(defs || []).length",
    v-for="d in [defs[definition]]")
    section.definitions(v-if="d.senses && d.senses.length")
      h3 Definitions
      ol
        li(v-for="sense in d.senses")
          p(v-if="sense.glosses", v-html="link_text(sense.glosses.join(', '))")
          ul
            li.word-example(v-for="ex in sense.examples")
              p(v-if="ex.text")
                span(v-html="link_text(ex.text)")
                |
                .fa.fa-headphones(@click="tts(ex.text)")
              p(v-if="ex.trans", v-html="link_text(ex.trans)")
              p.example-ref(v-if="ex.ref", v-html="'— ' + link_text(ex.ref)")

    section.usage(v-if="d.usage")
      h3 Usage
      p(v-html="link_text(d.usage)")

    section.etymology(v-if="d.etymology")
      h3 Etymology
      p(v-html="link_text(d.etymology)")

    section.translations(v-if="d.translations && d.translations.length")
      h3 Translations
      ul
        li(v-for="t in d.translations", v-html="t")

    section(v-if="d.inflections", v-for="inf in d.inflections")
      h3
        | Inflection
        |
        span(v-if="inf.kotus")
          | (Kotus type {{inf.kotus_num}}/
          router-link(:to="'/word/' + inf.kotus") {{inf.kotus}}
          | , {{inf.kpt ? inf.kpt : 'no gradation'}})

      Inflections(:forms="inf.forms")

    .related-words(v-if="d.related")
      section.related-words(v-for="(words, name) in d.related")
        h3 {{name.replaceAll('_', ' ')}}
        ul
          li(v-for="word in words", v-html="link_text(word)")
</template>

<style lang="stylus">
.word-view
  max-width 65em

  ul, ol
    padding-left 1.5em

    li
      > p
        margin 0.5em 0

  .audio
    cursor pointer

    &:hover
      color #888

  .word-title
    display flex
    flex-wrap wrap
    align-items center
    gap 0.5em

    select
      font-size 100%

    .fa-star
      color #bbb
      cursor pointer

      &.star
        color gold

  .word-notes
    flex 1

    form
      display flex
      gap 0.5em

      input
        flex 1
        padding 0.5em

      .fa
        font-size 22pt

      .save:not(:disabled) .fa
        color #0074e8

  .word-example
    margin 1em 0

    div > strong
      font-family mono

    > p
      > .fa-headphones
        visibility hidden

      &:hover > .fa-headphones
        visibility visible

  .example-ref
    font-style italic

  .related-words > h3
    text-transform capitalize
</style>
