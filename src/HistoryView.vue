<script>
export default {
  name: 'HistoryView',


  data() {
    return {
      history: [],
      loading: true,
    }
  },


  async activated() {
    this.loading = true
    this.history = await this.$api.get('/api/user/history')
    this.loading = false
  }
}
</script>

<template lang="pug">
h3(v-if="loading") Loading...
.history-view(v-else)
  label.history-word Word
  label.history-notes Comments
  label.history-time Time
  template(v-for="e in history")
    router-link.history-word(:to="'/word/' + e.word") {{e.word}}
    .history-notes {{e.notes}}
    .history-time(:title="e.time") {{$util.since(e.time)}} ago
</template>

<style lang="stylus">
.history-view
  display grid
  grid-template-columns 1fr 1fr 1fr
  gap 0.5em

  label
    font-weight bold

  .history-time
    text-align right
</style>