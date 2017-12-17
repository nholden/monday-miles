<template lang="pug">
  .activity
    .name {{ activity.name }}
    .map(v-html="activity.map")
    .details
      .detail {{ activity.date }}
      .detail {{ activity.miles }} miles
      .detail {{ activity.feetElev }} feet elev.
      .detail {{ activity.duration }} moving
      .detail
        a(:href="activity.stravaUrl" target="_blank" rel="noopener" class="strava-link")
          .strava-button
            | View on Strava
</template>

<script lang="coffee">
export default
  props:
    activity:
      required: true
</script>
