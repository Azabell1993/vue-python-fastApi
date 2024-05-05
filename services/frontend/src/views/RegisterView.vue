<template>
  <section>
    <form @submit.prevent="submit">
      <div class="mb-3">
        <label for="username" class="form-label">아이디</label>
        <input type="text" id="username" name="username" v-model="user.username" class="form-control" :class="{'is-invalid': usernameInvalid}" required />
        <div v-if="usernameInvalid" class="invalid-feedback">이미 존재하는 아이디입니다!</div>
      </div>
      <div class="mb-3">
        <label for="full_name" class="form-label">이름</label>
        <input type="text" name="full_name" v-model="user.full_name" class="form-control" required />
      </div>
      <div class="mb-3">
        <label for="password" class="form-label">패스워드</label>
        <input type="password" name="password" v-model="user.password" class="form-control" :class="{'is-invalid': passwordInvalid}" required />
        <div v-if="passwordInvalid" class="invalid-feedback">
          패스워드는 8자 이상이며, 대문자, 소문자, 숫자, 특수문자를 각각 하나 이상 포함해야 합니다.
        </div>
      </div>
      <button type="submit" class="btn btn-primary">회원가입</button>
    </form>
    <CustomAlert
      :message="alertMessage"
      :isVisible="isAlertVisible"
      @update:isVisible="isAlertVisible = $event" />
  </section>
</template>

<script>
import { defineComponent, ref } from 'vue';
import { mapActions } from 'vuex';
import CustomAlert from './CustomAlert.vue';

export default defineComponent({
  name: 'UserRegister',
  components: {
    CustomAlert
  },
  data() {
    return {
      user: {
        username: '',
        full_name: '',
        password: '',
      },
      alertMessage: ref(''),
      isAlertVisible: false
    };
  },
  computed: {
    passwordInvalid() {
      // Password validation logic
      const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])(.{8,})$/;
      return this.user.password && !passwordRegex.test(this.user.password);
    },
    usernameInvalid() {
      return this.isAlertVisible && this.alertMessage === '이미 존재하는 아이디입니다!';
    }
  },
  methods: {
    ...mapActions(['register']),
    async submit() {
      if (this.passwordInvalid) {
        this.alertMessage = '패스워드는 8자 이상이며, 대문자, 소문자, 숫자, 특수문자를 각각 하나 이상 포함해야 합니다.';
        this.isAlertVisible = true;
        return;
      }
      this.isAlertVisible = false; // Reset the alert visibility
      try {
        await this.register(this.user);
        this.alertMessage = '회원가입을 축하합니다!';
        this.isAlertVisible = true;
        setTimeout(() => {
          this.$router.push('/portfolio');
        }, 1000); // Success message and then navigate
      } catch (error) {
        this.alertMessage = '이미 존재하는 아이디입니다!';
        this.isAlertVisible = true;
      }
    }
  }
});
</script>