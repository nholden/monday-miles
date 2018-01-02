import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import VueTippy from 'vue-tippy'
import Activities from '../Activities.vue'
import LoadingVideo from '../LoadingVideo.vue'

Vue.use(TurbolinksAdapter)
Vue.use(VueTippy)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#vue-app',
    components: { Activities, LoadingVideo }
  })
})
