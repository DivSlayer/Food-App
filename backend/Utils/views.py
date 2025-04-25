import math
import random


# Create your views here.

def calculate_distance(coord1, coord2):
    # Radius of the Earth in kilometers
    R = 6371.0

    # Coordinates in radians
    lat1, lon1 = map(math.radians, coord1)
    lat2, lon2 = map(math.radians, coord2)

    # Differences in coordinates
    dlat = lat2 - lat1
    dlon = lon2 - lon1

    # Haversine formula
    a = math.sin(dlat / 2) ** 2 + math.cos(lat1) * math.cos(lat2) * math.sin(dlon / 2) ** 2
    c = 2 * math.asin(math.sqrt(a))

    # Distance in kilometers
    distance = R * c
    return distance


def generate_random_number(length=10):
    if length <= 0:
        raise ValueError("Length must be a positive integer.")

        # Generate a random number with the specified length
    lower_bound = 10 ** (length - 1)  # Minimum number with the specified length
    upper_bound = 10 ** length - 1  # Maximum number with the specified length

    return random.randint(lower_bound, upper_bound)


def get_model_field_list(model):
    # Retrieve the field names for non-relation fields
    food_fields = [
        field.name for field in model._meta.get_fields()
        if not (field.is_relation and field.related_model is not None)
    ]
    return food_fields