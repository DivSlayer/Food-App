
from rest_framework import permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from shapely import Polygon, Point
from Address.models import Address
from Category.models import Category
from Food.models import Food
from Food.serializers import FoodSerializer
from Restaurant.models import Restaurant
from Restaurant.serializers import RestaurantSerializer
from Utils.views import calculate_distance
import matplotlib.pyplot as plt


class CloseRestaurants(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def post(self, request):
        close = []
        data = request.data
        try:
            latitude = data['lat']
            longitude = data['long']
            latitude = float(latitude)
            longitude = float(longitude)
            restaurants = Restaurant.objects.all()
            for res in restaurants:
                if len(res.coverage) == 0:
                    address = (latitude, longitude)
                    res_addresses = Address.objects.filter(owner_account=res.owner_account)
                    for add in res_addresses:
                        res_address = (float(add.latitude), float(add.longitude))
                        print(f"res_add: {res_address}")
                        print(f"user: {address}")
                        distance = calculate_distance(address, res_address)
                        if distance <= 3:
                            close.append(res)
                            break
                else:
                    address = Point(latitude, longitude)
                    polygon = Polygon(res.coverage)
                    is_within = polygon.contains(address)
                    if is_within:
                        close.append(res)
            return Response({"restaurants": RestaurantSerializer(close, many=True,context={'small':True}).data})

        except Exception as e:
            return Response(status=status.HTTP_400_BAD_REQUEST)


class SingleRestaurantAPI(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, uuid):
        try:
            res = Restaurant.objects.get(uuid=uuid)
            serializer = RestaurantSerializer(res)
            cats = Category.objects.all()
            foods = Food.objects.filter(restaurant=res)
            my_dict = {cat.title: [FoodSerializer(food).data for food in foods.filter(category__title=cat.title)] for
                       cat in cats}
            my_dict = {k: v for k, v in my_dict.items() if v}
            data = dict(serializer.data)
            data['cats'] = my_dict
            return Response({"restaurants": [data]})
        except Restaurant.DoesNotExist as e:
            return Response('رستوران پیدا نشد!', status=status.HTTP_404_NOT_FOUND)

def show_mata(polygon, address):
    x, y = polygon.exterior.xy

    # Plot the polygon
    plt.plot(x, y, label='Polygon')

    # Plot the point
    plt.plot(address.x, address.y, 'ro', label='Point')

    # Add labels and legend
    plt.xlabel('Longitude')
    plt.ylabel('Latitude')
    plt.legend()
    plt.title('Polygon and Point Visualization')

    # Show the plot
    plt.show()
