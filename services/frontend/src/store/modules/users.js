import axios from 'axios';

const state = {
  user: JSON.parse(localStorage.getItem('user')) || null, // 초기 상태 설정
};

const getters = {
  isAuthenticated: state => !!state.user, // 이제 이 부분은 Vuex 상태를 기반으로 합니다.
  stateUser: state => state.user,
};

const actions = {
  async logIn({ commit }, user) {
    try {
      const response = await axios.post('login', user);
      if (response.data) {
        let { data } = await axios.get('users/whoami');
        await commit('setUser', data); // 사용자 객체 전체를 저장
        localStorage.setItem('user', JSON.stringify(data)); // 로컬 스토리지에 사용자 정보 저장
        return true;
      } else {
        throw new Error('로그인 정보를 확인할 수 없습니다.');
      }
    } catch (error) {
      throw new Error(error.response ? error.response.data.detail : '로그인 요청이 잘못되었습니다.');
    }
  },

  async register({ dispatch }, form) {
    try {
      const response = await axios.post('register', form);
      if (response.status === 201 && response.data) {
        let UserForm = new FormData();
        UserForm.append('username', form.username);
        UserForm.append('password', form.password);
        await dispatch('logIn', UserForm);
      }
    } catch (error) {
      console.error('Registration failed:', error);
      let errorMessage = '회원가입 과정에서 오류가 발생했습니다.';
      if (error.response) {
        if (error.response.status === 409) {
          errorMessage = '이미 사용중인 아이디입니다. 다른 아이디를 선택해 주세요.';
        } else if (error.response.status === 401 || (error.response.data && error.response.data.detail)) {
          errorMessage = error.response.data.detail;
        }
      } else if (error.request) {
        errorMessage = '회원가입 서비스에 접근할 수 없습니다. 네트워크 상태를 확인해주세요.';
      }
      throw new Error(errorMessage);
    }
  },

  async viewMe({ commit }) {
    let { data } = await axios.get('users/whoami');
    await commit('setUser', data);
  },

  async deleteUser(id) {
    await axios.delete(`user/${id}`);
  },

  async logOut({ commit }) {
    await commit('logout');
    localStorage.removeItem('user');
  }
};

const mutations = {
  setUser(state, user) {
    state.user = user;
  },
  logout(state) {
    state.user = null;
  }
};

export default {
  state,
  getters,
  actions,
  mutations
};
