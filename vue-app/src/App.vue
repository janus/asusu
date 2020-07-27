<template>
  <div class="vue-tempalte" >
    <!-- Navigation -->
    <nav class="navbar shadow bg-white rounded justify-content-between flex-nowrap flex-row fixed-top">
      <div class="container">
        <a class="navbar-brand float-left" href="/" >asusu.bank</a>
        <ul class="nav navbar-nav flex-row float-right" v-if="!loggedIn">
          <li class="nav-item">
            <router-link class="nav-link pr-3" to="/login">Sign in</router-link>
          </li>
          <li class="nav-item">
            <router-link class="btn btn-outline-primary" to="/signup">Sign up</router-link>
          </li>
        </ul>
        <ul class="nav navbar-nav flex-row float-right" v-if="loggedIn">
          <li class="nav-item">
            <router-link class="nav-link pr-3" to="/logout">Logout</router-link>
          </li>
        </ul>
      </div>
    </nav>
    <!-- Main -->
    <div class="App" v-if="!loggedIn">
      <div class="vertical-center" >
        <div class="inner-block">
          <router-view />
        </div>
      </div>
    </div>
    <div class="container" v-if="loggedIn">

          <router-view />

      </div>
  </div>
  
</template>

<script>
export default {
    name: "app",
    loginSuccessful: true,
    profile: {},
    text: "",
    data() {
      return {};
    },
    mounted() {
      this.loginSuccessful = this.$store.state.loginSuccessful;
      console.log("beforeMount")
    },
    methods: {
    },

    computed: {
      loggedIn() {
        return this.$store.state.profile.loginSuccessful;
      }
    }
}
</script>

<style>
.container {
  margin-top: 20px;
}
</style>


