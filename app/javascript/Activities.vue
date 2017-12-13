<template lang="pug">
  .activities
    .container(v-infinite-scroll="loadMore")
      activity(
        v-for="activity in activities"
        v-bind:activity="activity"
        v-bind:key="activity.id"
      )
    .loader
      .loading-indicator(v-if="loading")
        i(class="fa fa-spinner fa-pulse fa-fw")
        span Loading...
      .loading-link(v-else)
        a(v-on:click.prevent="loadMore" href='#') Load more
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
    loading: false
  mounted: -> @loadMore()
  methods:
    loadMore: ->
      @loading = true
      xhr = new XMLHttpRequest()
      xhr.open('GET', "#{@requestUrl}?page=#{@page}")
      xhr.onload = =>
        @activities = @activities.concat(JSON.parse(xhr.responseText))
        @loading = false
      xhr.send()
      @page += 1
  components: { Activity }
  directives: { infiniteScroll }
</script>
