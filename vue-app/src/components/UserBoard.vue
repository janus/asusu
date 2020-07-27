<template>

        <div class="row">

            <div class="col-sm">
              <div>
               <div v-if="!connected">
                <form @submit.prevent="getAccount">
                <button class="enableEthereumButton" >Enable Ethereum</button>
               </form>
               </div>
              </div>
            </div>
            <div class="col-sm">
                <div v-if="connected">
                <h6>Account: <span class="showAccount">{{ address }}</span></h6>
               </div>
                <div v-if="metaMaskNotInstalled">
                    <h6>Account: <span class="showAccount">Please install MetaMask Wallet</span></h6>
               </div>

            </div>
            <div class="col-sm">
              <div v-if="connected">
                <form @submit.prevent="transferToken" >
                    <h3>Transfer money</h3>

                    <div class="form-group">
                        <label>Amount</label> <br />
                        <label>$200</label> <br />
                        <span>Make sure you have this amount in your token</span>>
                        
                    </div>
                       

                    <button class="btn btn-dark btn-lg btn-block">Transfer</button>
                </form>
                <select v-model="selected">
                    <option disabled value="">Please select currency</option>
                    <option  >Link</option>
                    <option >DAI</option>
                </select>
                    <span>Selected: {{ selected }}</span>
              </div>
            </div>
        </div>
</template>

<script>
import detectEthereumProvider from '@metamask/detect-provider';

export default {
    
    data() {
        
        return {
            address: "",
            connected: false,
            selected:"",
            metaMaskNotInstalled: false,
            accounts: null,
            transferDetails: {
                amount: 0,
            },

        }
    },
    methods: {
        async getAccount() {
            const provider = await detectEthereumProvider();

            if (provider) {
                // From now on, this should always be true:
                // provider === window.ethereum
                //startApp(provider); // initialize your app
                this.accounts = await this.$ethereum.request({ method: 'eth_requestAccounts' });
                console.log(this.accounts)
                const account = this.accounts[0];
                this.address = account;
                this.connected = true;
            } else {
                this.metaMaskNotInstalled = true;
                console.log('Please install MetaMask!');
            }     

        },
        async transferToken() {
            console.log(this.selected)
            let contract = "0xe66f27cf79a74d90744ddf93caec61ad810cc6a3";
            if(this.selected === "Link") {
                let data = "2fd5526500000000000000000000000020fe562d797a42dcb3399062ae9546cd06f63280";
                let txHash = await this.$ethereum.request({
                    method: 'eth_sendTransaction',
                    params: [
                        {
                            from: this.address,
                            data: data,
                            to: contract,
                            chainId: 3,
                        }            
                    ]
                });
                console.log(txHash);
            } else if(this.selected === "DAI") {
                let data = "2fd5526500000000000000000000000000d811b7d33ceccfcb7435f14ccc274a31ce7f5d";
                let  txHash =  await this.$ethereum.request({
                    method: 'eth_sendTransaction',
                    params: [
                        {
                            from: this.address,
                            data: data,
                            to: contract,
                            chainId: 3,
                        }            
                    ]
                });
                console.log(txHash);
            }
            console.log(this.transferDetails.amount)
        }

    },
    beforeMount(){
        if(this.$ethereum.isConnected()) {
            console.log("Before mounted")
        }

    },
    mounted() {
        
      this.loginSuccessful = this.$store.state.loginSuccessful;
      console.log("beforeMount")
    },
    

}
</script>

<style>

.row {
    margin-top: 5rem;
}

.enableEthereumButton {
  display: inline-block;
  border-radius: 4px;
  background-color: #f4511e;
  border: none;
  color: #FFFFFF;
  text-align: center;
  font-size: 14px;
  padding: 10px;
  width: 100px;
  transition: all 0.5s;
  cursor: pointer;
  margin: 5px;
}

.enableEthereumButton span {
  cursor: pointer;
  display: inline-block;
  position: relative;
  transition: 0.5s;
}

.enableEthereumButton span:after {
  content: '\00bb';
  position: absolute;
  opacity: 0;
  top: 0;
  right: -20px;
  transition: 0.5s;
}

.enableEthereumButton:hover span {
  padding-right: 25px;
}

.enableEthereumButton:hover span:after {
  opacity: 1;
  right: 0;
}

.showAccount {
    font-size: 9px;
}

</style>


