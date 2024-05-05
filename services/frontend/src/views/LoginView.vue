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
      <div v-if="message" class="alert alert-success mt-3">{{ message }}</div>
      <div v-if="error" class="alert alert-danger mt-3">{{ error }}</div>
    </form>
  </section>
</template>

<script>
import { defineComponent } from 'vue';
import { mapActions, mapState } from 'vuex';

export default defineComponent({
  name: 'UserLogin',
  data() {
    return {
      form: {
        username: '',
        password: ''
      },
      message: '',
      error: ''
    };
  },
  computed: {
    ...mapState(['loginInfo'])
  },
  methods: {
    ...mapActions(['logIn']),
    async submit() {
      try {
        const User = new FormData();
        User.append('username', this.form.username);
        User.append('password', this.form.password);
        await this.logIn(User);
        this.$router.push('/portfolio');
      } catch (error) {
        this.error = error.message;
      }
    },
  },
  mounted() {
    // Vuex로부터 로그인 정보를 가져와 폼을 채우기
    if (this.loginInfo) {
      this.form.username = this.loginInfo.username;
      this.form.password = this.loginInfo.password;
      this.submit(); // 자동 로그인 시도
    }
  }
});
</script>
