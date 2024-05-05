import axios from 'axios';

const state = {
  user: null,
};

const getters = {
  isAuthenticated: state => !!state.user,
  stateUser: state => state.user,
};

const actions = {

  async logIn({ commit }, user) {
    try {
      const response = await axios.post('login', user);
      // 로그인 성공 후 사용자 정보 검증
      let {data} = await axios.get('users/whoami');
      await commit('setUser', data);
      if (response.data && data) {
        return true;
      } else {
        throw new Error('로그인 정보를 확인할 수 없습니다.');
      }
    } catch (error) {
      console.error('로그인 에러:', error.response ? error.response.data.detail : error.message);
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
  
  async viewMe({commit}) {
    let {data} = await axios.get('users/whoami');
    await commit('setUser', data);
  },
  
  // eslint-disable-next-line no-empty-pattern
  async deleteUser({}, id) {
    await axios.delete(`user/${id}`);
  },
  async logOut({commit}) {
    let user = null;
    commit('logout', user);
  }
};

const mutations = {
  setUser(state, username) {
    state.user = username;
  },
  logout(state, user){
    state.user = user;
  }
};

export default {
  state,
  getters,
  actions,
  mutations
};