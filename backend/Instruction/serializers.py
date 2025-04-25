from rest_framework import serializers

from Instruction.models import Instruction
from food_backend.env import Env

SERVER = Env().get_server()


class InstructionSerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField('get_image')

    class Meta:
        model = Instruction
        fields = ['uuid', 'name', 'image', 'price']

    def get_image(self, ins):
        return SERVER + ins.image.url
