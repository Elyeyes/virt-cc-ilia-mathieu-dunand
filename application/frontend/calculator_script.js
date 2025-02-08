const url_api = 'calculatrice-dunand-mathieu.polytech-dijon.kiowy.net/api';

function appendNumber(number) {
    document.getElementById('display').value += number;
}

function appendOperator(operator) {
    document.getElementById('display').value += ' ' + operator + ' ';
}

function calculate() {
    const display = document.getElementById('display');
    fetch(`${url_api}/calculate`, {
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
    fetch(`${url_api}/result/${id}`)
    .then(response => response.json())
    .then(data => {
        if (data.error) {
            display.value = data.error;
        } else {
            display.value = data.result || data;
        }
    })
    .catch(error => {
        display.value = 'Error';
    });
}

function clearDisplay() {
    document.getElementById('display').value = '';
}

