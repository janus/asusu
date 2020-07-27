import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    profile: {
      name: "",
      loginSuccessful: null
    },
  },
  mutations: {
    updateName(state, name) {
    state.profile.name = name;
    },
    updateLoginSuccessful(state, bool) {
      state.profile.loginSuccessful = bool;
      }
  },
  actions: {},
  modules: {}
});
