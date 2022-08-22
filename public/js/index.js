var ul = document.querySelector('ul')
for (var i = 0; i < fracts.length; i++) {
    var li = document.createElement('li')
    var button = document.createElement('button')
    button.setAttribute('onclick',"window.location.href = '/" + fracts[i] + "'")
    button.innerHTML = capitalizeFirstLetter(fracts[i])
    li.appendChild(button)
    ul.appendChild(li)
}

function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}