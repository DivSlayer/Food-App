import os

from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from Instruction.models import Instruction
from Instruction.serializers import InstructionSerializer
from Restaurant.models import Restaurant


class InstructionsListAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        is_restaurant = request.user.is_restaurant
        if is_restaurant:
            instruction = Instruction.objects.filter(restaurant__owner_account__phone=request.user.phone)
            return Response({'instructions': InstructionSerializer(instruction, many=True).data})
        else:
            return Response(status=status.HTTP_403_FORBIDDEN)
    def post(self, request):
        serializer = InstructionSerializer(data=request.data)
        image_file = request.FILES.get('image', None)

        # Validate and save the serializer
        if serializer.is_valid():
            res = Restaurant.objects.get(owner_account__phone=request.user.phone)
            # Create the extra instance
            instruction = Instruction(**serializer.validated_data, restaurant=res)
            instruction.save()

            # Handle image file if present
            if image_file is not None:
                # Handle previous image removal
                if instruction.image:  # Check if extra has an existing image before trying to remove it
                    try:
                        if os.path.isfile(instruction.image.path):
                            os.remove(instruction.image.path)
                    except Exception as e:
                        print(f"Error removing file: {e}")

                # Save the new image
                instruction.image = image_file
                instruction.save()  # Save the instance again with the new image

            # Return the response with serialized data
            return Response(InstructionSerializer(instruction).data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class SingleInstructionAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, uuid):
        try:
            instruction = Instruction.objects.get(uuid=uuid)
            if instruction.restaurant.owner_account == request.user:
                serializer = InstructionSerializer(instruction)
                return Response({'instructions': [serializer.data]})
            return Response({'error': 'Not allowed'}, status=status.HTTP_403_FORBIDDEN)
        except Instruction.DoesNotExist:
            return Response({'error': 'instruction not found!'}, status=status.HTTP_404_NOT_FOUND)

    def put(self, request, uuid):
        try:
            instruction = Instruction.objects.get(uuid=uuid)
            if instruction.restaurant.owner_account == request.user:
                serializer = InstructionSerializer(instruction, data=request.data, context={'user': request.user},
                                             partial=True)
                if serializer.is_valid():
                    serializer.save()
                    return Response({'instructions': [serializer.data]})
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Instruction.DoesNotExist:
            return Response({'error': 'Transaction not found!'}, status=status.HTTP_404_NOT_FOUND)


    def delete(self, request, uuid):
        try:
            instruction = Instruction.objects.get(uuid=uuid)
            if instruction.restaurant.owner_account == request.user:
                instruction.delete()
                return Response()
            return Response({'error':'Something went wrong'}, status=status.HTTP_400_BAD_REQUEST)
        except Instruction.DoesNotExist as e:
            return Response({'error': 'iInstruction not found!'}, status=status.HTTP_404_NOT_FOUND)

