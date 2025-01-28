const url_api = 'http://127.0.0.1:5000/api';

function appendNumber(number) {
    document.getElementById('display').value += number;
}

function appendOperator(operator) {
    document.getElementById('display').value += ' ' + operator + ' ';
}

function calculate() {
    const display = document.getElementById('display');
    fetch("http://127.0.0.1:5000/api/calculate", {
        method: "POST",
        body: JSON.stringify({
            expression: display.value
        }),
        headers: {
          "Content-type": "application/json; charset=UTF-8"
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.id) {
            displayResult(data.id);
        } else {
            display.value = data.error;
        }
    });
}

function displayResult(id) {
    const display = document.getElementById('display');
    fetch("http://127.0.0.1:5000/api/result/" + id)
    .then(response => response.json())
    .then(data => {
        display.value = data;
    });
}

function clearDisplay() {
    document.getElementById('display').value = '';
}

