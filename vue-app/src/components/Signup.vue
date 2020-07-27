<template>
    <div class="vue-tempalte">
        <form @submit.prevent="checkForm" v-if="!savingSuccessful">
            <h3>Sign Up</h3>
            
            <div v-if="errors.length">
            <b>Please correct the following error(s):</b>
            <ul>
            <li  v-bind:key="error" v-for="error in errors">{{ error }}</li>
            </ul>
            </div>
            <div class="form-group">
                <label>Full Name</label>
                <input v-model="user.name" type="text" class="form-control form-control-lg" @focus="clearStatus"/>
            </div>

            <div class="form-group">
                <label>Email address</label>
                <input v-model="user.email" type="email" class="form-control form-control-lg"  @focus="clearStatus"/>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input v-model="user.password" type="password" class="form-control form-control-lg" @focus="clearStatus"/>
            </div>

            <button class="btn btn-dark btn-lg btn-block">Sign Up</button>

            <p class="forgot-password text-right">
                Already registered 
                <router-link :to="{name: 'login'}">sign in?</router-link>
            </p>
        </form>
        <div class="success" v-if="savingSuccessful"> 
            {{ text }} 
        </div>
    </div>
</template>



<script>
    export default {
        name: "sign-up",
        savingSuccessful: false,
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
        methods: {
            handleSubmit() {
                console.log("testing handleSubmit");
                console.log(this.user.email);
                this.savingSuccessful = true;
                this.text = `${this.user.name} , please check your email box. Use the mail sent to you to complete registration.`
                this.user = [];
                
            },

            checkForm() {
                this.clearStatus()
                if(this.user.name && this.user.password) {
                    this.handleSubmit();
                    return true;

                }
                this.errors = [];
                if(!this.user.name) this.errors.push("Name required.");
                if(!this.user.email) this.errors.push("Email required.");
                if(!this.user.password) this.errors.push("Password required.");
                //e.preventDefault();
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

