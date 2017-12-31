<template lang="pug">
  .activities
    .year-selector
      | Showing activities from&nbsp;
      select(v-model="year")
        option(v-for="yearOption in yearOptions" :value="yearOption") {{yearOption}}
    .loader(v-show="loading")
      .loading-indicator
        i(class="fa fa-spinner fa-pulse fa-fw")
        span Loading...
    activity(
      v-show="!loading"
      v-for="activity in activities"
      :activity="activity"
      :key="activity.id"
    )
</template>

<script lang="coffee">
import Activity from 'Activity.vue'

export default
  props:
    requestUrl:
      required: true
    yearOptions:
      required: true

  data: ->
    year: @yearOptions[0]
    activities: []
    loading: false

  mounted: -> @loadActivities()

  watch:
    year: -> @loadActivities()

  methods:
    loadActivities: ->
      @loading = true
      xhr = new XMLHttpRequest()
      xhr.open('GET', "#{@requestUrl}?year=#{@year}")
      xhr.onload = =>
        @activities = JSON.parse(xhr.responseText).activities
        setTimeout((=> @loading = false), 1000)
      xhr.send()

  components: { Activity }
</script>
