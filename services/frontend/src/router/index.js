import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '@/views/HomeView.vue';
import RegisterView from '@/views/RegisterView.vue';
import LoginView from '@/views/LoginView.vue';
import WasmView from '@/views/WasmView.vue';
import DashboardView from '@/views/DashboardView.vue';
import NoteView from '@/views/NoteView.vue';
import EditNoteView from '@/views/EditNoteView.vue';
import store from '@/store'; // NEW

const routes = [
  {
    path: '/',
    name: "Home",
    component: HomeView,
  },
  {
    path: '/register',
    name: 'Register',
    component: RegisterView,
  },
  {
    path: '/login',
    name: 'Login',
    component: LoginView,
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: DashboardView,
    meta: { requiresAuth: true },
  },
  {
    path: '/note/:id',
    name: 'Note',
    component: NoteView,
    meta: { requiresAuth: true },
    props: true,
  },
  {
    path: '/editnote/:id',
    name: 'EditNote',
    component: EditNoteView,
    meta: { requiresAuth: true },
    props: true,
  },
  
  // 회원가입 및 로그인을 안하면 진입불가
  {
    path: '/portfolio',
    name: 'Portfolio',
    component: WasmView,
    beforeEnter: (to, from, next) => {
      if (store.getters.isAuthenticated) {
        next();
      } else {
        next('/login');
      }
    }
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

router.beforeEach((to, _, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (store.getters.isAuthenticated) {
      next();
      return;
    }
    next('/login');
  } else {
    next();
  }
});

export default router;
