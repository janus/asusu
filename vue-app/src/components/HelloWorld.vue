<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <p>
      This is a financial system that intends to allow people all over the world to pool 
      fund together and also distribute same<br />
      It is a trustless system, and participants don't have to know each other. The system sets the amount 
      each person is to contribute and the period the investment would last.
    </p>
    <p>
      Each month the system would pick a member of the financial pool and pay him/her a fraction that is the total fund
      divided by the number of participants. Actually, the number of months is a reflection of the number of participants.

      This systems would help people across the global to save money and build saving culture.
    </p>
  </div>
</template>

<script>
export default {
  name: "HelloWorld",
  props: {
    msg: String
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
