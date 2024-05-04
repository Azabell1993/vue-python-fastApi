<template>
  <section>
    <form @submit.prevent="submit">
      <div class="mb-3">
        <label for="username" class="form-label">Username:</label>
        <input type="text" name="username" v-model="form.username" class="form-control" />
      </div>
      <div class="mb-3">
        <label for="password" class="form-label">Password:</label>
        <input type="password" name="password" v-model="form.password" class="form-control" />
      </div>
      <button type="submit" class="btn btn-primary">Submit</button>
    </form>
    <div v-if="!isLoggedIn" class="alert alert-warning mt-3" role="alert">
      You are not logged in. Please <router-link to="/register">sign up</router-link> to continue.
    </div>
  </section>
</template>

<script>
import { defineComponent } from 'vue';
import { mapActions, mapGetters } from 'vuex';

export default defineComponent({
  name: 'UserLogin',
  data() {
    return {
      form: {
        username: '',
        password:'',
      }
    };
  },
  computed: {
    ...mapGetters(['isLoggedIn']),
  },
  methods: {
    ...mapActions(['logIn']),
    async submit() {
      const User = new FormData();
      User.append('username', this.form.username);
      User.append('password', this.form.password);
      await this.logIn(User);
      this.$router.push('/portfolio');
    }
  }
});
</script>
