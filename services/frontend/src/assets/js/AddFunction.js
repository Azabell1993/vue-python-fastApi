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