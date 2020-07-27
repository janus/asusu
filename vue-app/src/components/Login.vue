<template>
    <div class="vue-tempalte">
        <form @submit.prevent="checkForm" v-if="!savingSuccessful">
            <h3>Sign In</h3>

            <div class="form-group">
                <label>Email address</label>
                <input v-model="user.email" type="email" class="form-control form-control-lg" @focus="clearStatus"/>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input v-model="user.password" type="password" class="form-control form-control-lg" @focus="clearStatus"/>
            </div>

            <button type="submit" class="btn btn-dark btn-lg btn-block">Sign In</button>

            <p class="forgot-password text-right mt-2 mb-4">
                <router-link to="/forgot-password">Forgot password ?</router-link>
            </p>

            <div class="social-icons">
                <ul>
                    <li><a href="#"><i class="fa fa-google"></i></a></li>
                    <li><a href="#"><i class="fa fa-facebook"></i></a></li>
                    <li><a href="#"><i class="fa fa-twitter"></i></a></li>
                </ul>
            </div>

        </form>
    </div>
</template>



<script>
    export default {
        name: "login-in",
        savingSuccessful: false,
        text: "",
        data() {
            return {
                errors:[],  
                user: {
                    email: null,
                    password: null
                },
            }
        },
        methods: {
            handleSubmit() {
                console.log("loging");
                console.log(this.user.email);

                
                this.$store.commit('updateName', "Emeka")
                this.$store.commit('updateLoginSuccessful',  true)
                this.$router.push('/')
                console.log(this.$store.state.profile)
                this.user = [];
                
            },
            checkForm() {
                this.clearStatus()
                if(this.user.email && this.user.password) {
                    this.handleSubmit();
                    return true;

                }
                this.errors = [];
                if(!this.user.email) this.errors.push("Email required.");
                if(!this.user.password) this.errors.push("Password required.");
                //e.preventDefault();
            },
            clearStatus() {
                this.loginSuccessful = false;
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