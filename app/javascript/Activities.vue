<template lang="pug">
  .activities(v-infinite-scroll="loadMore" infinite-scroll-distance="60")
    activity(
      v-for="activity in activities"
      v-bind:activity="activity"
      v-bind:key="activity.id"
    )
</template>

<script lang="coffee">
import infiniteScroll from 'vue-infinite-scroll'
import Activity from 'Activity.vue'

export default
  props:
    requestUrl:
      required: true
  data: ->
    page: 1
    activities: []
  methods:
    loadMore: ->
      xhr = new XMLHttpRequest()
      xhr.open('GET', "#{@requestUrl}?page=#{@page}")
      xhr.onload = =>
        @activities = @activities.concat(JSON.parse(xhr.responseText))
        @page += 1
      xhr.send()
  components: { Activity }
  directives: { infiniteScroll }
</script>
