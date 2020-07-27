<template>
<div>
  <div class="home"  v-if="!loggedIn">
    <img alt="Asusu logo" src="../assets/dd.png" />
      <HelloWorld msg="Welcome to asusu App" />
    </div>
    <div v-if="loggedIn">
      <UserBoard />
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import HelloWorld from "@/components/HelloWorld.vue";
import UserBoard from "@/components/UserBoard.vue";

export default {
  name: "Home",
  components: {
    HelloWorld,
    UserBoard
  },
  computed: {
    loggedIn() {
      return this.$store.state.profile.loginSuccessful;
    }
  }
};
</script>
