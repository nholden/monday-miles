<template lang="pug">
  .activities
    activity(
      v-for="activity in activities"
      v-bind:activity="activity"
      v-bind:key="activity.id"
    )
</template>

<script lang="coffee">
import Activity from 'Activity.vue'

export default
  props:
    activities:
      required: true
  components: { Activity }
</script>
