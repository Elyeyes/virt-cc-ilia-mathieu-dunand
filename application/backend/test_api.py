import requests

BASE_URL = "http://127.0.0.1:5000"

def test_home():
    """Test de la route /"""
    response = requests.get(BASE_URL)
    if response.status_code == 200:
        print("Test de la route home réussi")
    else:
        print("Test route home failed")

def test_calculate():
    """Test calcul simple"""
    expression = '{"expression": "5+5"}'
    response = requests.post(f"{BASE_URL}/api/calculate", headers={"Content-Type": "application/json"}, data=expression)
    response_json = response.json()

    if response.status_code == 200 : 
        print("Test calcul réussi")
        print(f"Response: {response}, id : {response_json['id']}")
        return response_json["id"] 
    else:
        print("Test calcul failed")
        print(f"Response: {response}")
        return None

def test_get_result(result_id):
    """Test récupérer un calcul avec l'id"""
    response = requests.get(f"{BASE_URL}/api/result/{result_id}")
    response_json = response.json()

    if response.status_code == 200 :
        print("Resultat trouvé")
        print(f"Response: {response_json}")
    else:
        print("Resultat non trouvé")
        print(f"Response: {response_json}")

if __name__ == "__main__":
    print("Test")
    test_home()
    result_id = test_calculate()
    if result_id:
        test_get_result(result_id)
