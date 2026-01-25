<script>
export default {
  name: 'TagsView',


  data() {
    return {
      tags: []
    }
  },


  async mounted() {
    this.tags = await this.$api.get('/api/tags')
  },
}
</script>

<template lang="pug">
.tags-view
  h2 Tags

  .tag(v-for="tag in tags")
    router-link(:to="'/user/card/' + tag.uid + '/' + tag.name")
      .fa(:class="'fa-' + tag.name")
      span {{tag.name}} ({{tag.count}})
</template>

<style lang="stylus">
.tags-view
  display flex
  flex-direction column
  gap 0.5em

  h2
    margin 0

  .tag
    a
      text-decoration none

    .fa
      width 1.5em
      font-size 16pt
</style>