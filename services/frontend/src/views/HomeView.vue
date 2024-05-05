<template>
  <div class="container">
    <section class="main-section">
      <!-- 로그인 정보 제공 섹션 -->
      <div class="quick-login-info">
        <p>이 홈페이지는 Vue.js와 Python을 이용해서 만들었습니다.</p>
      </div>

      <template v-if="user">
        <p>현재 로그인한 사용자 (username) : [ <strong>{{ user.username }}</strong> ]님</p>
      </template>
      <template v-else>
        <p>로그인이 필요합니다.</p>
        <!-- 회원가입 및 로그인 버튼 -->
        <div class="auth-buttons">
          <button @click="goTo('/register')" class="btn btn-primary">회원가입</button>
          <span class="or-divider">or</span>
          <button @click="goTo('/login')" class="btn btn-secondary">로그인</button>
        </div>
      </template>

      <!-- 깃허브 저장소 링크 추가 -->
      <div class="github-link">
        <a href="https://github.com/Azabell1993/vue-python-fastApi" target="_blank">
          <img src="@/assets/images/github_logo.png" alt="GitHub Logo">
          GitHub 저장소 바로가기
        </a>
      </div>
    </section>

    <!-- 채용 관련 연락처 -->
    <section class="contact-info">
      <h2>Contact</h2>
      <p><strong>개발자:</strong> 박지우(Park Ji Woo)</p>
      <p><strong>이메일:</strong> <a href="mailto:moreirly@naver.com">moreirly@naver.com</a></p>
      <p><strong><img src="@/assets/images/github_logo.png" alt="GitHub Logo" class="github-logo"></strong> <a href="https://github.com/Azabell1993">@Azabell1993</a></p>
    </section>
  </div>
</template>

<script>
import { defineComponent, computed } from 'vue';
import { useStore } from 'vuex';

export default defineComponent({
  name: 'HomeView',
  setup() {
    const store = useStore();  // Vuex store를 사용합니다.
    const user = computed(() => store.getters.stateUser);

    return {
      user,
      goTo(path) {
        this.$router.push(path);
      }
    };
  }
});
</script>
