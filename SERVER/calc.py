import sys
import json
from geopy.distance import geodesic

def calculate_distance(user_location, monument_locations):
    user_lat, user_lng = user_location
    distances = []
    for monument in monument_locations:
        monument_lat, monument_lng = monument
        distance = geodesic((user_lat, user_lng), (monument_lat, monument_lng)).kilometers
        distances.append((monument, distance))
    distances.sort(key=lambda x: x[1])  # Sort by distance
    return distances[:5]  # Return 5 nearest monuments

if __name__ == "__main__":
    # Read user's location and monument locations from command-line arguments
    user_location = json.loads(sys.argv[1])
    monument_locations = json.loads(sys.argv[2])

    # Calculate nearest monuments
    nearest_monuments = calculate_distance(user_location, monument_locations)

    # Print nearest monuments as JSON string
    print(json.dumps(nearest_monuments))
