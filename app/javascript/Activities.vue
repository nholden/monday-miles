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
    .result(v-show="!loading")
      .year-summary
        .stat {{summary.activityCount}} activities
        .stat {{summary.miles}} miles
        .stat {{summary.feetElev}} feet elev.
        .stat {{summary.hours}} hours
      activity(
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
    summary: {}
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
        parsedResponse = JSON.parse(xhr.responseText)
        @summary = parsedResponse.summary
        @activities = parsedResponse.activities
        setTimeout((=> @loading = false), 1000)
      xhr.send()

  components: { Activity }
</script>
