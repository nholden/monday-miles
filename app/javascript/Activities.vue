<template lang="pug">
  .activities
    .year-selector
      | Monday activities in&nbsp;
      select(v-model="year")
        option(v-for="yearOption in yearOptions" :value="yearOption") {{yearOption}}
    .loader(v-show="loading")
      .loading-indicator
        i(class="fa fa-spinner fa-pulse fa-fw")
        span Loading...
    .result(v-show="!loading")
      .graph
        svg(
          width="100%"
          :viewBox="'0 0 64 ' + graphHeight"
        )
          rect(
            v-for="(monday, index) in mondays"
            v-tippy=""
            v-on:focus="selectedMonday = monday"
            v-on:blur="selectedMonday = null"
            class="day"
            :class="{ 'day--completed': mondayHasCompletedActivity(monday), 'day--selected': selectedMonday == monday }"
            :title="monday.display"
            :x="(index % 13) * 5"
            :y="mondayVerticalGraphPosition(index)"
            width="4"
            height="4"
          )
      .year-summary
        .stat {{summary.activityCount}} activities
        .stat {{summary.miles}} miles
        .stat {{summary.feetElev}} feet elev.
        .stat {{summary.hours}} hours
      activity(
        v-for="activity in activities"
        v-show="showActivity(activity)"
        :activity="activity"
        :key="activity.id"
      )
</template>

<script lang="coffee">
import Activity from 'Activity.vue'
import _ from 'lodash'

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
    mondays: []
    selectedMonday: null
    loading: false

  mounted: -> @loadActivities()

  watch:
    year: -> @loadActivities()

  computed:
    graphHeight: ->
      if @mondays.length > 0
        @mondayVerticalGraphPosition(@mondays.length - 1) + 4
      else
        0

  methods:
    loadActivities: ->
      @loading = true
      xhr = new XMLHttpRequest()
      xhr.open('GET', "#{@requestUrl}?year=#{@year}")
      xhr.onload = =>
        parsedResponse = JSON.parse(xhr.responseText)
        @summary = parsedResponse.summary
        @activities = parsedResponse.activities
        @mondays = parsedResponse.mondays
        setTimeout((=> @loading = false), 1000)
      xhr.send()
    mondayHasCompletedActivity: (monday) ->
      @activitiesCompletedOnMonday(monday).length > 0
    activitiesCompletedOnMonday: (monday) ->
      _.filter(@activities, { year: monday.year, month: monday.month, day: monday.day })
    mondayVerticalGraphPosition: (index) -> Math.floor(index/13) * 5
    showActivity: (activity) ->
      _.isNil(@selectedMonday) || @activitiesCompletedOnMonday(@selectedMonday).includes(activity)

  components: { Activity }
</script>
