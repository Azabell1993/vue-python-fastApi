const { defineConfig } = require('@vue/cli-service');

module.exports = defineConfig({
  transpileDependencies: true,
  configureWebpack: {
    experiments: {
      asyncWebAssembly: true  // WebAssembly 모듈을 비동기적으로 로드
    },
    module: {
      rules: [
        {
          test: /\.wasm$/,  // .wasm 확장자를 가진 파일 처리
          type: 'webassembly/async',  // WebAssembly 파일을 비동기 모듈로 처리
        }
      ]
    }
  }
});