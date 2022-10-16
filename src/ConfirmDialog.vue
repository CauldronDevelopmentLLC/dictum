<script>
export default {
  data() {
    return {
      message: '',
      show: false
    }
  },


  methods: {
    open(message, cb) {
      this.message = message
      this.show = true
      this.cb = cb
    },


    close() {this.show = false},


    respond(ok) {
      if (this.cb) this.cb(ok)
      this.close()
    }
  }
}
</script>

<template lang="pug">
Dialog.confirm-dialog(v-if="show")
  template(v-slot:header) Please confirm
  template(v-slot:body): p {{message}}
  template(v-slot:footer)
    button(@click="respond(false)") #[.fa.fa-times] Cancel
    button(@click="respond(true)") #[.fa.fa-check] Ok
</template>

<style lang="stylus">
</style>
