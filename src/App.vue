<script>
export default {
  data() {
    return {
      search: '',
      lang: localStorage.getItem('dictum-lang') || 'en',
      user_tags: []
    }
  },


  watch: {
    lang() {localStorage.setItem('dictum-lang', this.lang)}
  },


  async mounted() {
    if (this.$user.name)
      this.user_tags = await this.$api.get('/api/user/tags')
  },


  methods: {
    async login() {this.$user = await this.$api.login()},


    async logout() {
      await this.$api.logout()
      location.reload()
    },


    lookup() {this.$router.push('/word/' + this.search.trim())},


    clear() {
      this.search = ''
      this.$refs.search.focus()
    },


    search_input(e) {
      this.search = e.target.value.replace(/;/g, 'ö').replace(/'/g, 'ä')
    }
  }
}
</script>

<template lang="pug">
header
  router-link.title(to="/") Dictum

  select.language(v-if="$route.path.indexOf('/word/') == 0",
    v-model="lang", title="Select dictionary language")
    option(value="en") EN
    option(value="fi") FI

  .logout.fa.fa-sign-out(v-if="$user.name && $route.path == '/account'",
    @click="logout", title="Logout")

  router-link(to="/account", v-if="$user.name", title="Account")
    img.avatar(:src="$user.avatar")
  .fa.fa-sign-in(v-else, @click="login", title="Login with Google")

main
  form.search(@submit.prevent="lookup")
    input(ref="search", :value="search",
      @input="search_input", autocorrect="off" autocapitalize="none",
      placeholder="Enter word")
    button(@click="lookup", :disabled="!search"): .fa.fa-search
    button(@click.prevent="clear"): .fa.fa-eraser

  router-view(v-slot="{Component}")
    KeepAlive
      component(:is="Component", :search="search")
</template>

<style lang="stylus">
body
  display flex
  flex-direction column
  width calc(100vw - 1em)
  margin 0
  font-size 90%
  padding 0.5em

  > div
    display flex
    flex-direction column
    gap 0.5em

button
  &:not(:disabled)
    cursor pointer

.button
  cursor pointer
  text-decoration none
  color #222

  &:hover
    opacity 0.6

.button, button
  display inline-flex
  gap 0.5em
  align-items center
  padding 0.25em

  .fa
    font-size 16pt

.word-tag.fa
  font-size 24pt
  color #bbb
  cursor pointer
  width 30px
  text-align center

  &.active
    color gold

  &:hover
    opacity 0.6

header
  display flex
  flex-direction row
  gap 0.5em

  > *
    height 48px

  .title
    flex 1
    font-size 24pt
    text-decoration none
    color #000

  .language
    font-size 16pt

  .fa
    font-size 36pt
    cursor pointer

  .avatar
    cursor pointer
    width 48px
    height 48px
    overflow hidden
    border-radius 5px

    &:hover
      opacity 0.6

main
  display flex
  flex-direction column
  gap 1em

  .search
    display flex
    gap 0.25em

    input
      flex 1

    .fa
      font-size 250%
      cursor pointer

</style>
