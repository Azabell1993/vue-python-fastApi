<template>
    <div v-if="isVisible" class="custom-alert">
      <div class="alert-overlay">
        <div class="alert-content">
          <p>{{ message }}</p>
          <button class="btn btn-primary" @click="close">닫기</button>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      message: String,
      isVisible: Boolean
    },
    emits: ['update:isVisible'],
    setup(props, { emit }) {
      const close = () => {
        emit('update:isVisible', false);
      };
  
      return { close };
    }
  }
  </script>
  
  <style scoped>
  .alert-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
  }
  
  .alert-content {
    background: white;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
  </style>
  