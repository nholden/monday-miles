<template lang="pug">
  .activity
    .name {{ activity.name }}
    .map(v-html="activity.map")
    .details
      .detail {{ activity.date }}
      .detail {{ activity.miles }} miles
      .detail {{ activity.feetElev }} feet elev.
      .detail {{ activity.hours }} hours
</template>

<script lang="coffee">
export default
  props:
    activity:
      required: true
</script>
