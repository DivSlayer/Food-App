from rest_framework import serializers

from Extras.models import Extra
from Instruction.models import Instruction
from food_backend.env import Env

SERVER = Env().get_server()


class ExtraSerializer(serializers.ModelSerializer):
    icon = serializers.SerializerMethodField('get_image')

    class Meta:
        model = Extra
        fields = ['uuid', 'name', 'icon', 'price']

    def get_image(self, ins):
        return SERVER + ins.icon.url
