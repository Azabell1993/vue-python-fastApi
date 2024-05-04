<template>
  <section>
    <p>이 홈페이지는 Vue.js와 Python을 이용해서 만들었습니다.</p>

    <div v-if="isLoggedIn" id="logout">
      <p id="logout">Click <a href="/dashboard">here</a> to view all notes.</p>
    </div>
    <p v-else>
      <span><a href="/register" class="register-button">회원가입</a></span>
      <span> or </span>
      <span><a href="/login" class="login-button">로그인</a></span>
    </p>
  </section>
</template>

<script>
import { defineComponent } from 'vue';
import '@/assets/css/main.css';

export default defineComponent({
  name: 'HomeView',
  computed: {
    isLoggedIn: function() {
      return this.$store.getters.isAuthenticated;
    }
  },
});
</script>
