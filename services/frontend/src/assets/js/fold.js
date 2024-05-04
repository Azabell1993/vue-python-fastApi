var elements = document.getElementsByTagName("div");

for (var i = 0; i < elements.length; i++) {
    if (elements[i].className == "elements") {
      elements[i].style.display="none";
    } else if (elements[i].className == "label") {
      elements[i].onclick=switchDisplay;
    }
  }

function switchDisplay() {
  var parent = this.parentNode;
  var target = parent.getElementsByTagName("div")[1];

  if (target.style.display == "none") {
    target.style.display="block";
  } else {
    target.style.display="none";
  }
  return false;
}