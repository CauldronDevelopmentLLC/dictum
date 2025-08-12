<script>
export default {
  data() {
    return {
      search: '',
    }
  },


  methods: {
    async login() {this.$user = await this.$api.login()},


    async logout() {
      await this.$api.logout()
      location.reload()
    },


    lookup() {this.$router.push('/word/' + this.search)},


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

  img.avatar(:src="$user.avatar", :title="'Logout ' + $user.name",
    @click="logout", v-if="$user.name")
  .fa.fa-sign-in(v-else, @click="login")

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
  width 100vw
  margin 0
  font-size 90%

button:not(:disabled)
  cursor pointer


header
  padding 0.25rem 0.5rem
  font-size 150%
  display flex
  flex-direction row
  gap 0.5em

  .title
    flex 1
    font-size 150%
    text-decoration none
    color #000

  .fa
    font-size 250%
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
  padding 0.5rem

  .search
    display flex
    gap 0.25em

    input
      flex 1

    .fa
      font-size 250%
      cursor pointer

</style>
