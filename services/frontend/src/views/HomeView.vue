<template>
  <section>
    
    <!-- 로그인 정보 제공 섹션 -->
    <div class="quick-login-info">
      <p>이 홈페이지는 Vue.js와 Python을 이용해서 만들었습니다.</p>
      <p>회원가입이 귀찮으신 분은</p>
      <p>아이디: test / 비밀번호: 1234</p>
    </div>

    <div v-if="isLoggedIn" id="logout">
      <p id="logout">Click <a href="/dashboard">here</a> to wasm test space.</p>
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
  methods: {
  }
});
</script>
