import os

from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from Extras.models import Extra
from Extras.serializers import ExtraSerializer
from Restaurant.models import Restaurant


class ExtrasListAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        is_restaurant = request.user.is_restaurant
        if is_restaurant:
            extras = Extra.objects.filter(restaurant__owner_account__phone=request.user.phone)
            return Response({'extras': ExtraSerializer(extras, many=True).data})
        else:
            return Response(status=status.HTTP_403_FORBIDDEN)

    def post(self, request):
        serializer = ExtraSerializer(data=request.data)
        image_file = request.FILES.get('icon', None)

        # Validate and save the serializer
        if serializer.is_valid():
            res = Restaurant.objects.get(owner_account__phone=request.user.phone)
            # Create the extra instance
            extra = Extra(**serializer.validated_data, restaurant=res)
            extra.save()

            # Handle image file if present
            if image_file is not None:
                # Handle previous image removal
                if extra.icon:  # Check if extra has an existing image before trying to remove it
                    try:
                        if os.path.isfile(extra.icon.path):
                            os.remove(extra.icon.path)
                    except Exception as e:
                        print(f"Error removing file: {e}")

                # Save the new image
                extra.icon = image_file
                extra.save()  # Save the instance again with the new image

            # Return the response with serialized data
            return Response(ExtraSerializer(extra).data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class SingleExtraAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, uuid):
        try:
            extra = Extra.objects.get(uuid=uuid)
            if extra.restaurant.owner_account == request.user:
                serializer = ExtraSerializer(extra)
                return Response({'extras': [serializer.data]})
            return Response({'error': 'Not allowed'}, status=status.HTTP_403_FORBIDDEN)
        except Extra.DoesNotExist:
            return Response({'error': 'extra not found!'}, status=status.HTTP_404_NOT_FOUND)

    def put(self, request, uuid):
        try:
            extra = Extra.objects.get(uuid=uuid)
            if extra.restaurant.owner_account == request.user:
                serializer = ExtraSerializer(extra, data=request.data, context={'user': request.user},
                                             partial=True)
                if serializer.is_valid():
                    serializer.save()
                    new_serializer = ExtraSerializer(extra)
                    print('This is the serializer')
                    print(new_serializer.data)
                    return Response({'extras': [new_serializer.data]})
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Extra.DoesNotExist:
            return Response({'error': 'Extra not found!'}, status=status.HTTP_404_NOT_FOUND)


    def delete(self, request, uuid):
        try:
            extra = Extra.objects.get(uuid=uuid)
            if extra.restaurant.owner_account == request.user:
                extra.delete()
                return Response()
            return Response({'error':'Something went wrong'}, status=status.HTTP_400_BAD_REQUEST)
        except Extra.DoesNotExist as e:
            return Response({'error': 'Extra not found!'}, status=status.HTTP_404_NOT_FOUND)

