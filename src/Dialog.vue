<template lang="pug">
.dialog-mask
  .dialog-wrapper
    .dialog-container
      .dialog-header
        slot(name="header") default header
      .dialog-body
        slot(name="body") default body
      .dialog-footer
        slot(name="footer")
          button(@click="$emit('close')") OK
</template>


<style lang="stylus">
.dialog-mask
  position fixed
  z-index 9998
  top 0
  left 0
  width 100%
  height 100%
  background-color rgba(0, 0, 0, 0.5)
  display table

.dialog-wrapper
  display table-cell
  vertical-align middle

.dialog-container
  width 30em
  margin 0px auto
  background-color #fff
  border 2px solid #666
  display flex
  flex-direction column

  > *
    padding 1em

  .dialog-header
    border-top-left-radius 2px
    border-top-right-radius 2px
    background #ccc
    font-weight bold

  .dialog-body
    display flex
    flex-direction column
    gap 0.5em
    padding-top 2em

    .fields
      display grid
      grid-template-columns 8em auto
      grid-gap 0.5em

      label
        font-weight bold
        text-align right

      input
        text-align left
        margin 0

  .dialog-footer
    border-bottom-left-radius 2px
    border-bottom-right-radius 2px
    text-align right

    button
      margin-left 0.5em
      padding 0.5em
</style>
