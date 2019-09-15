<template lang="pug">
  .activities
    .year-selector
      | Monday activities in&nbsp;
      select(v-model="year")
        option(v-for="yearOption in yearOptions" :value="yearOption") {{yearOption}}
    .result(:class="{ 'result--loading': loading }")
      .graph(v-click-outside="onClickOutsideGraph")
        svg(
          width="100%"
          :viewBox="'0 0 64 ' + graphHeight"
        )
          rect(
            v-for="(monday, index) in mondays"
            v-tippy=""
            v-on:focus="selectedMonday = monday"
            class="day"
            :class="{ 'day--completed': mondayHasCompletedActivity(monday), 'day--selected': selectedMonday == monday }"
            :title="monday.display"
            :x="(index % 13) * 5"
            :y="mondayVerticalGraphPosition(index)"
            width="4"
            height="4"
          )
      .year-summary
        .stat {{summary.activityCount}} {{'activity' | pluralize(summary.activityCount)}}
        .stat {{summary.miles}} miles
        .stat {{summary.feetElev}} feet elev.
        .stat {{summary.hours}} hours
      activity(
        v-for="activity in filteredActivities"
        :activity="activity"
        :key="activity.id"
      )
</template>

<script lang="coffee">
import Activity from 'Activity.vue'
import _ from 'lodash'
import vClickOutside from 'v-click-outside'

export default
  directives:
    clickOutside: vClickOutside.directive

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

  filters:
    pluralize: (word, count) ->
      if count == 1
        word
      else
        switch word.slice(-1)
          when 'y' then "#{word.slice(0, -1)}ies"
          else "#{word}s"

  watch:
    year: -> @loadActivities()

  computed:
    graphHeight: ->
      if @mondays.length > 0
        @mondayVerticalGraphPosition(@mondays.length - 1) + 4
      else
        0
    filteredActivities: ->
      if _.isNil(@selectedMonday)
        @activities
      else
        @activitiesCompletedOnMonday(@selectedMonday)

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
        @loading = false
      xhr.send()
    mondayHasCompletedActivity: (monday) ->
      @activitiesCompletedOnMonday(monday).length > 0
    activitiesCompletedOnMonday: (monday) ->
      _.filter(@activities, { year: monday.year, month: monday.month, day: monday.day })
    mondayVerticalGraphPosition: (index) -> Math.floor(index/13) * 5
    onClickOutsideGraph: (event) ->
      unless event.target.closest('a')
        @selectedMonday = null

  components: { Activity }
</script>
