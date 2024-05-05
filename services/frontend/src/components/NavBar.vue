<template>
  <header>
    <nav class="navbar navbar-expand-md navbar-dark bg-dark">
      <div class="container">
        <a class="navbar-brand">JIWOO PORTFOLIO</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
          <ul v-if="isLoggedIn" class="navbar-nav me-auto mb-2 mb-md-0">
            <li class="nav-item">
              <router-link class="nav-link" to="/">홈으로</router-link>
            </li>
            <li class="nav-item">
              <router-link class="nav-link" to="/portfolio">포트폴리오</router-link>
            </li>
            <!-- <li class="nav-item">
              <router-link class="nav-link" to="/dashboard">Dashboard</router-link>
            </li> -->
            <li class="nav-item">
              <a class="nav-link" @click="logout">로그아웃</a>
            </li>
          </ul>
          <ul v-else class="navbar-nav me-auto mb-2 mb-md-0">
            <li class="nav-item">
              <router-link class="nav-link" to="/">홈으로</router-link>
            </li>
            <li class="nav-item">
              <router-link class="nav-link" to="/register">회원가입</router-link>
            </li>
            <li class="nav-item">
              <router-link class="nav-link" to="/login">로그인</router-link>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  </header>
</template>

<script>
import { defineComponent } from 'vue';
import { mapGetters } from 'vuex';

export default defineComponent({
  name: 'NavBar',
  computed: {
    ...mapGetters({user: 'stateUser'}),
    isLoggedIn: function() {
      return this.$store.getters.isAuthenticated;
    }
  },
  methods: {
    async logout () {
      await this.$store.dispatch('logOut');
      this.$router.push('/login');
    }
  },
});
</script>

<style scoped>
a {
  cursor: pointer;
}
</style>
