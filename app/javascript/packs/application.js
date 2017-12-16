import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import Activities from '../Activities.vue'
import LoadingVideo from '../LoadingVideo.vue'

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#vue-app',
    components: { Activities, LoadingVideo }
  })
})
