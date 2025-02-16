const url_api = 'http://calculatrice-dunand-mathieu.polytech-dijon.kiowy.net/api';
// const url_api = 'http://localhost:5000/api';

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
        headers: {
            "Content-type": "application/json; charset=UTF-8"
          },        
        body: JSON.stringify({
            expression: display.value
        })
    })
    .then(async response => {
        const text = await response.text();
        try {
          return JSON.parse(text);
        } catch {
          console.error("Erreur backend: ", text);
          throw new Error("Le backend a retourné une erreur HTML");
        }
    })
    .then(data => {
        if (data.id) {
            displayResult(data.id);
        } else {
            display.value = data.error;
        }
    })
    .catch(error => {
        console.error('Erreur opération fetch : ', error);
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

