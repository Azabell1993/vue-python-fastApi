<template>
  <section id="banner">
    <div class="content">
      <header>
        <h2>Vue.js + Python FastAPI + WASM 연동 Test</h2><br>
      </header>
      <ul class="actions">
        <h5>C언어 Function Test</h5>
        <br/>
          <input type="number" v-model="numA" size="20"> + <input type="number" v-model="numB" size="20">
          <button class="mybutton btn btn-primary" :disabled="!isModuleLoaded" @click="performAddition">덧셈해보기</button>
          <!-- <p id="textcontent">{{ resultMessage }}</p> -->
          <CustomAlert 
            :message="alertMessage" 
            :isVisible="isAlertVisible"
            @update:isVisible="isAlertVisible = $event" />
      </ul>
    </div>
    <img src="@/assets/images/mainPic.png" style="width: 100%; height: auto;" alt="">
    
      <header class="main">
        <h1>사용된 코드</h1>
        </header>
        <!-- Content -->
        <h2 id="content">살펴보기</h2>
        <p>이 블로그에는 C/C++언어를 와즘과 연동하여 연습한 샘플 코드들이 있습니다.</p>
        <div class="row">
          <div class="col-12 col-12-small">
            <details>
            <summary>Header Code File</summary>
            <pre><code>
  #pragma once
  #ifndef PROGRAM_H
  #define PROGRAM_H

  #include &lt;stdio.h&gt;
  #include &lt;stdbool.h&gt;
  #include &lt;assert.h&gt;
  #include &lt;memory.h&gt;
                            
  #define class struct
  #define public static __attribute__((visibility("default")))
  #define private static __attribute__((visibility("hidden")))
                              
  #ifdef __cheaderfile
  extern "C" {
  #endif
  #ifndef BUILD_MY_DLL
  #define SHARED_LIB __declspec(dllexport)
  #else
  #define SHARED_LIB __declspec(dllexport)
  #endif
  #ifdef _GNUC_
  #define NORETERN _attribute_ ((_noreturn_))
    /* 함수 전방 선언 */
    extern public void addFunction##_set_Add(addFunction *, type, type);
    extern public int addFunction##_get_Add(const addFunction *);
                              
    /* 비멤버 생성자 전방 선언 */
    addFunction new_##addFunction(void);
  #endif
                            
  #define say_add(addFunction, int)

  class addFunction;           
  typedef class addFunction addFunction;
                                  
  class addFunction
  {
    /* 필드 변수 선언 */        
    int num1;         
    int num2;         
                                    
    /* 캡슐화를 돕는 구조체 포인터 전방에 선언 */
    /* 후방에는 피라메터로 함수 포인터와 지역 인수들을 선언*/
    /* 피라메타의 선언이 짧아지고 쉬워졌다. */ 
    void (*setAdd)(addFunction *, int, int);
    int (*getAdd)(const addFunction *);     
  };        
                                  
  public void addFunction##_set_Add(addFunction *this, int num1, int num2)
  {
    this -> num1 = num1;
    this -> num2 = num2;
  }
                                
  public int addFunction##_get_Add(const addFunction *this)
  {
    int result = 0;          
    result = this->num1 + this->num2; 
    return result;           
  }         
                                  
  addFunction new_##addFunction(void)   
  {         
    static addFunction temp =    
    { 
      .num1 = 0,       
      .num2 = 0,       
      .setAdd = addFunction##_set_Add,
      .getAdd = addFunction##_get_Add,
    };
    return temp;             
    }
  #ifdef __cplusplus
  }
  #endif //__cplusplus
  #endif							
  </code></pre>
  </details>

  <details>
  <summary>Main Code File</summary>
  <pre><code>
  //EMSCRIPTEN_KEEPALIVE
  #include "addFunction.h"
  #include &lt;stdio.h&gt;
  #include &lt;emscripten.h&gt;

  int AddResult(int numA, int numB);

  #ifdef __cplusplus
  extern "C" {
  #endif

  say_add(addFunction , int)

  EMSCRIPTEN_KEEPALIVE 
  int AddResult(int numA, int numB)
  {
    addFunction add = new_addFunction();
    add.setAdd(&add, numA, numB);
    int result = add.getAdd(&add); 
    return (result);  
  }

  #ifdef __cplusplus
  }
  #endif
            </code></pre>
            </details>
            
            <details>
            <summary>Test용 JS Code File</summary>
            <pre><code>
  document.querySelector('.mybutton').addEventListener('click', function() {
    let AddResult;
    fetch("./wasm/add.wasm")
    .then(bytes => bytes.arrayBuffer())
    .then(mod => WebAssembly.compile(mod))
    .then(module => { return new WebAssembly.Instance(module)})
    .then(Instance => {
      AddResult = Instance.exports.AddResult(numA.value, numB.value);
      console.log("The AddResult = " + AddResult);
      document.getElementById("textcontent").innerHTML = "The AddResult = " + AddResult;
      alert( "방문해주셔서 감사합니다!!\n\n" + "합계는 \n" + AddResult);
    });
  });
            </code></pre>
            </details>

            <details>
              <summary>Vue.js + WASM Porting</summary>
              <pre><code>
  // 필요한 Vue 함수와 컴포넌트를 불러온다.
  import { defineComponent, ref, onMounted } from 'vue';
  import CustomAlert from './CustomAlert.vue'; // CustomAlert.vue 컴포넌트를 가져온다.

  // defineComponent 함수를 사용하여 Vue 컴포넌트를 정의한다.
  export default defineComponent({
    name: 'HelloView', // 컴포넌트의 이름을 'HelloView'로 설정한다.
    components: {
      CustomAlert // 'CustomAlert' 컴포넌트를 로컬 컴포넌트로 등록한다.
    },
    setup() {
      // ref 함수를 사용하여 반응형 참조 데이터를 생성한다.
      const numA = ref(0); // 첫 번째 숫자 입력값을 위한 반응형 참조, 초기값은 0
      const numB = ref(0); // 두 번째 숫자 입력값을 위한 반응형 참조, 초기값은 0
      const resultMessage = ref(''); // 연산 결과를 저장할 반응형 참조
      const alertMessage = ref(''); // 경고 메시지 내용을 저장할 반응형 참조
      const isAlertVisible = ref(false); // 경고창의 표시 여부를 제어하는 반응형 참조
      const isModuleLoaded = ref(false); // WebAssembly 모듈의 로드 완료 여부를 확인하는 반응형 참조
      let wasmModule = null; // 로드된 WebAssembly 모듈의 인스턴스를 저장할 변수

      // 컴포넌트가 마운트된 후 실행할 작업을 정의
      onMounted(async () => {
        try {
          // WebAssembly 모듈을 서버에서 가져온다.
          const response = await fetch('/wasm/add.wasm');

          // 가져온 모듈을 인스턴스화한다.
          const { instance } = await WebAssembly.instantiateStreaming(response);

          // 인스턴스를 변수에 저장한다.
          wasmModule = instance;

          // 모듈 로드가 성공적으로 완료되었음을 설정한다.
          isModuleLoaded.value = true; 
        } catch (error) {
          // 모듈 로드 중 오류가 발생하면 콘솔에 에러 메시지를 출력한다.
          console.error('Failed to load WASM module:', error);
        }
      });
      
      // 덧셈을 수행하는 함수를 정의한다.
      async function performAddition() {
        if (!wasmModule) {
          // WASM 모듈이 로드되지 않았다면 오류를 발생시킨다.
          throw new Error("WASM module is not loaded yet.");
        }
        // WASM 모듈의 AddResult 함수를 호출하여 두 입력값의 합을 계산한다.
        const AddResult = wasmModule.exports.AddResult;
        const result = AddResult(parseInt(numA.value), parseInt(numB.value));

        // 결과를 resultMessage에 저장한다.
        resultMessage.value = `The Add Result = ${result}`;
        
        // 사용자에게 보여줄 메시지를 설정한다.
        alertMessage.value = `방문해주셔서 감사합니다!!\n\n합계는 \n${result}`;
        
        // 경고창을 활성화한다.
        isAlertVisible.value = true; 
      }

      // setup 함수에서 생성한 모든 반응형 참조와 함수를 반환한다.
      // 이 반환값은 템플릿에서 바로 사용할 수 있습니다.
      return {
        numA, numB, resultMessage, performAddition, isModuleLoaded, alertMessage, isAlertVisible
      };
    }
  });


              </code></pre>
            </details>
          </div>
        </div>
  </section>
</template>

<script>
// 필요한 Vue 함수와 컴포넌트를 불러온다.
import { defineComponent, ref, onMounted } from 'vue';
import CustomAlert from './CustomAlert.vue'; // CustomAlert.vue 컴포넌트를 가져온다.

// defineComponent 함수를 사용하여 Vue 컴포넌트를 정의한다.
export default defineComponent({
  name: 'HelloView', // 컴포넌트의 이름을 'HelloView'로 설정한다.
  components: {
    CustomAlert // 'CustomAlert' 컴포넌트를 로컬 컴포넌트로 등록한다.
  },
  setup() {
    // ref 함수를 사용하여 반응형 참조 데이터를 생성한다.
    const numA = ref(0); // 첫 번째 숫자 입력값을 위한 반응형 참조입니다. 초기값은 0입니다.
    const numB = ref(0); // 두 번째 숫자 입력값을 위한 반응형 참조입니다. 초기값은 0입니다.
    const resultMessage = ref(''); // 연산 결과를 저장할 반응형 참조입니다.
    const alertMessage = ref(''); // 경고 메시지 내용을 저장할 반응형 참조입니다.
    const isAlertVisible = ref(false); // 경고창의 표시 여부를 제어하는 반응형 참조입니다.
    const isModuleLoaded = ref(false); // WebAssembly 모듈의 로드 완료 여부를 확인하는 반응형 참조입니다.
    let wasmModule = null; // 로드된 WebAssembly 모듈의 인스턴스를 저장할 변수입니다.

    // 컴포넌트가 마운트된 후 실행할 작업을 정의한다.
    onMounted(async () => {
      try {
        // WebAssembly 모듈을 서버에서 가져온다.
        const response = await fetch('/wasm/add.wasm');
        // 가져온 모듈을 인스턴스화한다.
        const { instance } = await WebAssembly.instantiateStreaming(response);
        wasmModule = instance; // 인스턴스를 변수에 저장한다.
        isModuleLoaded.value = true; // 모듈 로드가 성공적으로 완료되었음을 설정한다.
      } catch (error) {
        // 모듈 로드 중 오류가 발생하면 콘솔에 에러 메시지를 출력한다.
        console.error('Failed to load WASM module:', error);
      }
    });
    
    // 덧셈을 수행하는 함수를 정의한다.
    async function performAddition() {
      if (!wasmModule) {
        // WASM 모듈이 로드되지 않았다면 오류를 발생시킨다.
        throw new Error("WASM module is not loaded yet.");
      }
      // WASM 모듈의 AddResult 함수를 호출하여 두 입력값의 합을 계산한다.
      const AddResult = wasmModule.exports.AddResult;
      const result = AddResult(parseInt(numA.value), parseInt(numB.value));
      resultMessage.value = `The Add Result = ${result}`; // 결과를 resultMessage에 저장한다.
      alertMessage.value = `방문해주셔서 감사합니다!!\n\n합계는 \n${result}`; // 사용자에게 보여줄 메시지를 설정한다.
      isAlertVisible.value = true; // 경고창을 활성화한다.
    }

    // setup 함수에서 생성한 모든 반응형 참조와 함수를 반환한다.
    // 이 반환값은 템플릿에서 바로 사용할 수 있습니다.
    return {
      numA, numB, resultMessage, performAddition, isModuleLoaded, alertMessage, isAlertVisible
    };
  }
});

</script>
