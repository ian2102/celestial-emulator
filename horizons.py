import requests

# Define the list of planet IDs
planets = [199, 299, 399, 499, 599, 699, 799, 899]

# Function to extract and format data
def extract_data(data):
    lines = data.split('\n')
    planet_data = {}
    for i, line in enumerate(lines):
        if line.startswith('$$SOE'):
            line = lines[i + 1]
            break
    
    elements = line.split(',')
    planet_id = elements[0]
    x, y, z, vx, vy, vz, lt, rg, rr = elements[2:11]

    return {
        'X': {
            'value': float(x),
            'unit': 'km'
        },
        'Y': {
            'value': float(y),
            'unit': 'km'
        },
        'Z': {
            'value': float(z),
            'unit': 'km'
        },
        'VX': {
            'value': float(vx),
            'unit': 'km/sec'
        },
        'VY': {
            'value': float(vy),
            'unit': 'km/sec'
        },
        'VZ': {
            'value': float(vz),
            'unit': 'km/sec'
        },
        'LT': {
            'value': float(lt),
            'unit': 'sec'
        },
        'RG': {
            'value': float(rg),
            'unit': 'km'
        },
        'RR': {
            'value': float(rr),
            'unit': 'km/sec'
        }
    }

planet_data = {}

# Iterate through planets and request data
for planet_id in planets:
    f = f"""
    !$$SOF
    COMMAND='{planet_id}'
    EPHEM_TYPE='VECTORS'
    CENTER='500@10'
    START_TIME='2027-May-5 12:30:22'
    STOP_TIME='2027-May-5 12:30:23'
    STEP_SIZE='1 m'
    CSV_FORMAT='YES'
    """

    url = 'https://ssd.jpl.nasa.gov/api/horizons_file.api'
    r = requests.post(url, data={'format': 'text'}, files={'input': f})
    
    if r.status_code == 200:
        planet_data[planet_id] = extract_data(r.text)
    else:
        print(f"Failed to retrieve data for planet {planet_id} with status code {r.status_code}")

for planet_id, data in planet_data.items():
    print(f"Planet ID: {planet_id}")
    for param, values in data.items():
        value = values['value']
        unit = values['unit']
        print(f"{param}: {value} {unit}")
    print("---------------------------------")