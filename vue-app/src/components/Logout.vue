<template>
    <div class="vue-tempalte">
            <h3>Leaving...</h3>
    </div>
</template>



<script>
    export default {
        name: "log-out",
        text: "",
        data() {
            return {
                errors:[],
                
                user: {
                    
                    name: null,
                    email: null,
                    password: null
                },
            }
        },
          mounted() {
            this.$store.commit('updateName', "")
            this.$store.commit('updateLoginSuccessful',  false)
            //this.$router.push('/');
        },
        methods: {
            handleSubmit() {
                console.log("testing handleSubmit");
                console.log(this.user.email);
                this.savingSuccessful = true;
                this.text = `${this.user.name} , please check your email box. Use the mail sent to you to complete registration.`
                this.user = [];
                
            },
            clearStatus() {
                this.savingSuccessful = false;
                this.text = '';
                this.errors = [];
            }
        },
        computed: {
            hasMyObject: function() {
                return this.user.name.length;
            },
        },
    }
</script>

