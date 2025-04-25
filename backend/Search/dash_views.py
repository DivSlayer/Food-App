from fuzzywuzzy import fuzz, process
from rest_framework import permissions
from rest_framework.views import APIView
from rest_framework.response import Response

from Extras.models import Extra
from Extras.serializers import ExtraSerializer
from Food.models import Food
from Food.serializers import FoodSerializer
from Instruction.models import Instruction
from Instruction.serializers import InstructionSerializer
from Restaurant.models import Restaurant
from Search.engine import SearchEngine
from Transaction.models import TransactionModel
from Transaction.serializers import TransactionSerializer
from Transaction.views import get_related_transactions, list_to_queryset


class SearchView(APIView):
    permission_classes = (permissions.IsAuthenticated,)

    def get(self, request, *args, **kwargs):
        query = request.GET.get('q', '')

        if not isinstance(query, str):
            return Response({'error': 'Query must be a string'}, status=400)

            # Retrieve restaurant related to the user
        res = Restaurant.objects.get(owner_account__phone=request.user.phone)

        # Get all objects
        food_results = Food.objects.filter(restaurant=res)
        instruction_results = Instruction.objects.filter(restaurant=res)
        extra_results = Extra.objects.filter(restaurant=res)
        transactions = get_related_transactions(request.user)
        new_queryset = list_to_queryset(TransactionModel, transactions)
        transactions = TransactionSerializer(new_queryset, many=True, context={'user': request.user}).data
        matched_foods = SearchEngine(query, 'name', FoodSerializer(food_results, many=True).data).search()
        matched_instructions = SearchEngine(query, 'name',
                                            InstructionSerializer(instruction_results, many=True).data).search()
        matched_extras = SearchEngine(query, 'name', ExtraSerializer(extra_results, many=True).data).search()
        matched_transactions = SearchEngine(query, 'serial', transactions).search()

        results = {
            'foods': matched_foods,
            'instructions': matched_instructions,
            'extras': matched_extras,
            'transactions': matched_transactions,
        }

        return Response(results)
