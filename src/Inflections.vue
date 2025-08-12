<script>
let _forms = {
  'noun_sg': [
    '{nom_sg}',
    '{acc_sg}',
    '{par_sg}',
    '{gen_sg}',
    '{ill_sg}',
    '{ine_sg}',
    '{ela_sg}',
    '{all_sg}',
    '{ade_sg}',
    '{abl_sg}',
    '{ess_sg}',
    '{tra_sg}',
    '—',
    '{abe_sg}',
    '—',
  ],
  'noun_pl': [
    '{nom_pl}',
    '{acc_pl}',
    '{par_pl}',
    '{gen_pl}',
    '{ill_pl}',
    '{ine_pl}',
    '{ela_pl}',
    '{all_pl}',
    '{ade_pl}',
    '{abl_pl}',
    '{ess_pl}',
    '{tra_pl}',
    '{ins_pl}',
    '{abe_pl}',
    '{com_pl}',
  ],
  'poss_sg': [
    '{pos_1sg}',
    '{pos_2sg}',
    '{pos_3}',
  ],
  'poss_pl': [
    '{pos_1pl}',
    '{pos_2pl}',
    '{pos_3}',
  ],
  'comp': [
    '{comp}'
  ],
  'supr': [
    '{sup}'
  ],
  'adv_sg': [
    'singular',
    '{sss_sg}',
    '{del_sg}',
    '{sub_sg}',
    '{lat_sg}',
    '{tmp_sg}',
    '{cau_sg}',
    '{mul_sg}',
    '{dis_sg}',
    '{tdt_sg}',
    '{pro_sg}',
    '{sit_sg}',
    '{opp_sg}',
  ],
  'adv_pl': [
    'plural',
    '{sss_pl}',
    '{del_pl}',
    '{sub_pl}',
    '{lat_pl}',
    '{tmp_pl}',
    '{cau_pl}',
    '{mul_pl}',
    '{dis_pl}',
    '{tdt_pl}',
    '{pro_pl}',
    '{sit_pl}',
    '{opp_pl}',
  ],
  'pres': [
    '{pres_1sg}',
    '{pres_2sg}',
    '{pres_3sg}',
    '{pres_1pl}',
    '{pres_2pl}',
    '{pres_3pl}',
    '{pres_pasv}',
  ],
  'pres_neg': [
    'en {pres_conn}',
    'et {pres_conn}',
    'ei {pres_conn}',
    'emme {pres_conn}',
    'ette {pres_conn}',
    'eivät {pres_conn}',
    'ei {pres_pasv_conn}',
  ],
  'past': [
    '{past_1sg}',
    '{past_2sg}',
    '{past_3sg}',
    '{past_1pl}',
    '{past_2pl}',
    '{past_3pl}',
    '{past_pasv}',
  ],
  'past_neg': [
    'en {past_part}',
    'et {past_part}',
    'ei {past_part}',
    'emme {past_part_pl}',
    'ette {past_part_pl}',
    'eivät {past_part_pl}',
    'ei {past_pasv_part}',
  ],
  'perf': [
    'olen {past_part}',
    'olet {past_part}',
    'on {past_part}',
    'olemme {past_part_pl}',
    'olette {past_part_pl}',
    'ovat {past_part_pl}',
    'on {past_pasv_part}',
  ],
  'perf_neg': [
    'en ole {past_part}',
    'et ole {past_part}',
    'ei ole {past_part}',
    'emme ole {past_part_pl}',
    'ette ole {past_part_pl}',
    'eivät ole {past_part_pl}',
    'ei ole {past_pasv_part}',
  ],
  'plup': [
    'olin {past_part}',
    'olit {past_part}',
    'oli {past_part}',
    'olimme {past_part_pl}',
    'olitte {past_part_pl}',
    'olivat {past_part_pl}',
    'oli {past_pasv_part}',
  ],
  'plup_neg': [
    'en ollut {past_part}',
    'et ollut {past_part}',
    'ei ollut {past_part}',
    'emme olleet {past_part_pl}',
    'ette olleet {past_part_pl}',
    'eivät olleet {past_part_pl}',
    'ei ollut {past_pasv_part}',
  ],
  'impr': [
    '—',
    '{impr_2sg}',
    '{impr_3sg}',
    '{impr_1pl}',
    '{impr_2pl}',
    '{impr_3pl}',
    '{impr_pasv}',
  ],
  'impr_neg': [
    '—',
    'älä {impr_2sg}',
    'älköön {impr_conn}',
    'älkäämme {impr_conn}',
    'älkää {impr_conn}',
    'älkööt {impr_conn}',
    'älköön {impr_pasv_conn}',
  ],
  'impr_perf': [
    '—',
    'ole {past_part}',
    'olkoon {past_part}',
    'olkaamme {past_part_pl}',
    'olkaa {past_part_pl}',
    'olkoot {past_part_pl}',
    'olkoon {past_pasv_part}',
  ],
  'impr_perf_neg': [
    '—',
    'älä ole {past_part}',
    'älköön olko {past_part}',
    'älkäämme olko {past_part_pl}',
    'älkää olko {past_part_pl}',
    'älkööt olko {past_part_pl}',
    'älköön olko {past_pasv_part}',
  ],
  'cond': [
    '{cond_1sg}',
    '{cond_2sg}',
    '{cond_3sg}',
    '{cond_1pl}',
    '{cond_2pl}',
    '{cond_3pl}',
    '{cond_pasv}',
  ],
  'cond_neg': [
    'en {cond_conn}',
    'et {cond_conn}',
    'ei {cond_conn}',
    'emme {cond_conn}',
    'ette {cond_conn}',
    'eivät {cond_conn}',
    'ei {cond_pasv_conn}',
  ],
  'cond_perf': [
    'olisin {past_part}',
    'olisit {past_part}',
    'olisi {past_part}',
    'olisimme {past_part_pl}',
    'olisitte {past_part_pl}',
    'olisivat {past_part_pl}',
    'olisi {past_pasv_part}',
  ],
  'cond_perf_neg': [
    'en olisi {past_part}',
    'et olisi {past_part}',
    'ei olisi {past_part}',
    'emme olisi {past_part_pl}',
    'ette olisi {past_part_pl}',
    'eivät olisi {past_part_pl}',
    'ei olisi {past_pasv_part}',
  ],
  'potn': [
    '{potn_1sg}',
    '{potn_2sg}',
    '{potn_3sg}',
    '{potn_1pl}',
    '{potn_2pl}',
    '{potn_3pl}',
    '{potn_pasv}',
  ],
  'potn_neg': [
    'en {potn_conn}',
    'et {potn_conn}',
    'ei {potn_conn}',
    'emme {potn_conn}',
    'ette {potn_conn}',
    'eivät {potn_conn}',
    'ei {potn_pasv_conn}',
  ],
  'potn_perf': [
    'lienen {past_part}',
    'lienet {past_part}',
    'lienee {past_part}',
    'lienemme {past_part_pl}',
    'lienette {past_part_pl}',
    'lienevät {past_part_pl}',
    'lienee {past_pasv_part}',
  ],
  'potn_perf_neg': [
    'en liene {past_part}',
    'et liene {past_part}',
    'ei liene {past_part}',
    'emme liene {past_part_pl}',
    'ette liene {past_part_pl}',
    'eivät liene {past_part_pl}',
    'ei liene {past_pasv_part}',
  ],
  'part_act': [
    '{pres_part}',
    '{past_part}',
    '{past_part_pl}',
    '{agnt_part}',
    '{nega_part}',
  ],
  'part_pas': [
    '{pres_pasv_part}',
    '{past_pasv_part}',
    '—',
    '—',
    '—',
  ],
  'inf_act': [
    '{inf1}',
    '{inf1_long}',
    '{inf2_ine}',
    '{inf2_ins}',
    '{inf3_ill}',
    '{inf3_ine}',
    '{inf3_ela}',
    '{inf3_ade}',
    '{inf3_abe}',
    '{inf3_ins}',
    '{inf4_nom}',
    '{inf4_par}',
    '{inf5}',
  ],
  'inf_pas': [
    '—',
    '—',
    '{inf2_pasv_ine}',
    '{inf3_pasv_ins}',
    '—',
    '—',
    '—',
    '—',
    '—',
    '—',
    '—',
    '—',
    '—',
  ],
}

let _cases = {
  'nounal': [
    'nominative',
    'accusative',
    'partitive',
    'genitive',
    'illative',
    'inessive',
    'elative',
    'allative',
    'adessive',
    'ablative',
    'essive',
    'translative',
    'instructive',
    'abessive',
    'comitative',
  ],
  'possessive': [
    '1st person',
    '2nd person',
    '3nd person',
  ],
  'adjectival': [''],
  'adverbial': [
    'superessive',
    'delative',
    'sublative',
    'lative',
    'temporal',
    'causative',
    'multiplicative',
    'distributive',
    'temporal distributive',
    'prolative',
    'situative',
    'oppositive',
  ],
  'personal': [
    'minä',
    'sinä',
    'hän',
    'me',
    'te',
    'he',
    'passive',
  ],
  'participle': [
    'present',
    'past',
    'past plural',
    'agent',
    'negative',
  ],
  'infinitive': [
    '1st',
    '1st long',
    '2nd inessive',
    '2nd instructive',
    '3rd illative',
    '3rd inessive',
    '3rd elative',
    '3rd adessive',
    '3rd abessive',
    '3rd instructive',
    '4th nominative',
    '4th partitive',
    '5th',
  ]
}


let _tables = [
  {
    cases:  'nounal',
    cols: [
      ['singular', 'noun_sg'],
      ['plural',   'noun_pl'],
    ]
  }, {
    header: 'possessives',
    cases:  'possessive',
    cols: [
      ['singular', 'poss_sg'],
      ['plural',   'poss_pl'],
    ]
  }, {
    header: 'adjectival',
    cases: 'adjectival',
    cols: [
      ['comparative', 'comp'],
      ['superlative', 'supr'],
    ]
  }, {
    header: 'adverbial',
    cases: 'adverbial',
    cols: [
      ['singular', 'adv_sg'],
      ['plural',   'adv_pl'],
    ]
  }, {
    header: 'indicative',
    cases: 'personal',
    cols: [
      ['present',    'pres'],
      ['past',       'past'],
      ['perfect',    'perf'],
      ['pluperfect', 'plup'],
    ]
  }, {
    header: 'indicative',
    cases: 'personal',
    cols: [
      ['present negative',    'pres_neg'],
      ['past negative',       'past_neg'],
      ['perfect negative',    'perf_neg'],
      ['pluperfect negative', 'plup_neg'],
    ]
  }, {
    header: 'imperative',
    cases: 'personal',
    cols: [
      ['present positive', 'impr'],
      ['present negative', 'impr_neg'],
      ['perfect positive', 'impr_perf'],
      ['perfect negative', 'impr_perf_neg'],
    ]
  }, {
    header: 'conditional',
    cases: 'personal',
    cols: [
      ['present positive', 'cond'],
      ['present negative', 'cond_neg'],
      ['perfect positive', 'cond_perf'],
      ['perfect negative', 'cond_perf_neg'],
    ]
  }, {
    header: 'potential',
    cases: 'personal',
    cols: [
      ['present positive', 'potn'],
      ['present negative', 'potn_neg'],
      ['perfect positive', 'potn_perf'],
      ['perfect negative', 'potn_perf_neg'],
    ]
  }, {
    header: 'participles',
    cases: 'participle',
    cols: [
      ['active',  'part_act'],
      ['passive', 'part_pas'],
    ]
  }, {
    header: 'infinitives',
    cases: 'infinitive',
    cols: [
      ['active',  'inf_act'],
      ['passive', 'inf_pas'],
    ]
  }
]


function build_table(table) {
  // Make header and columns
  let hdr  = [table.header || '']
  let cols = [_cases[table.cases]]

  for (let col of table.cols) {
    hdr.push(col[0])
    cols.push(_forms[col[1]])
  }

  // Make rows
  let rows = [hdr]

  for (let i = 0; i < cols[0].length; i++) {
    let row = []

    for (let j = 0; j < cols.length; j++)
      row.push(cols[j][i])

    rows.push(row)
  }

  return rows
}


function uses_table(table, forms) {
  let found = false

  function lookup(m, form) {found = !!forms[form]}

  for (let row of table.slice(1))
    for (let text of row.slice(1)) {
      text.replace(/\{([^}]*)\}/, lookup)
      if (found) return true
    }

  return false
}


function split_table(table, columns) {
  let tables = []
  let offset = 1

  while (offset < table[0].length) {
    let t = []

    for (let row of table)
      t.push([row[0]].concat(row.slice(offset, offset + columns)))

    offset += columns
    tables.push(t)
  }

  return tables
}


export default {
  props: ['forms'],


  data() {
    return {
      width: document.body.offsetWidth
    }
  },


  computed: {
    tables() {
      let tables = []
      let w = this.width
      let cols = w < 950 ? (w < 650 ? 1 : 2) : 4

      for (let table of _tables) {
        table = build_table(table)
        if (uses_table(table, this.forms))
          tables = tables.concat(split_table(table, cols))
      }

      return tables
    }
  },


  mounted()   {window.addEventListener   ('resize', this.on_resize)},
  unmounted() {window.removeEventListener('resize', this.on_resize)},


  methods: {
    on_resize() {this.width = document.body.offsetWidth},

    resolve_forms(text) {
      let forms = this.forms
      let index = -1

      function lookup(m, form) {
        let words = forms[form]
        if (!words) return '—'

        if (index == -1) index = 0
        let word = words[index++]
        if (words.length == index) index = -1

        return word
      }

      let results = []
      do {
        results.push(text.replace(/\{([^}]*)\}/, lookup))
      } while (index != -1)

      return results
    },


    tts(text) {
      if (text != '—') this.$util.tts(text)
    },
  }
}
</script>

<template lang="pug">
.inflections
  table(v-for="(table, index) in tables")
    tr
      th(v-for="name in table[0]") {{name}}

    tr(v-for="row in table.slice(1)")
      th {{row[0]}}
      td(v-for="text in row.slice(1)")
        div(v-for="w in resolve_forms(text)", @click="tts(w)")
          | {{w}}
          |
          .fa.fa-headphones(v-if="w != '—'")
</template>

<style lang="stylus">
.inflections
  table
    border-collapse collapse
    box-shadow 2px 4px 5px 3px rgba(0, 0, 0, 0.15)
    margin-bottom 1em

    td, th
      padding 4px 12px
      border 1px solid #bbb
      vertical-align top
      width 12em

      &:first-child
        width 8em

    th
      text-align left
      background #ddd

    tr:first-child
      th:first-child
        text-transform capitalize
        font-size 110%
        color #000
        background #bbb

    tr:nth-child(odd)
      td
        background #f7f7f7

    td
      > div
        word-break break-word
        hyphens auto
        cursor pointer

        > .fa-headphones
          position absolute
          margin-left 0.25em
          visibility hidden

        &:hover > .fa-headphones
          visibility visible
</style>
