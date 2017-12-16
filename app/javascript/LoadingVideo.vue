<template lang="pug">
  #player
</template>

<script lang="coffee">
import YouTubePlayer from 'youtube-player'

export default
  props:
    redirectPath:
      required: true

  mounted: ->
    @mountPlayer()
    setTimeout(@redirect, 60000)

  methods:
    mountPlayer: -> YouTubePlayer('player',
      height: '390'
      width: '640'
      videoId: '98mBl9d0dew'
      playerVars:
        'autoplay': 1
        'controls': 0
        'disablekb': 1
        'modestbranding': 1
        'showinfo': 0
      ).on('stateChange', (event) =>
        @redirect() if (event.data == 0)
      )
    redirect: -> window.location = @redirectPath
</script>
