from fuzzywuzzy import fuzz, process
from rest_framework.views import APIView
from rest_framework.response import Response

class SearchView(APIView):
    def get(self, request, *args, **kwargs):
        query = request.GET.get('q', '')

        # Get all objects
        food_results = Food.objects.all()
        instruction_results = Instruction.objects.all()
        extra_results = Extra.objects.all()
        transaction_results = TransactionModel.objects.all()

        # Helper function to convert objects to strings
        def to_string(obj):
            return str(obj.name)

        # Perform fuzzy matching and ensure all inputs are strings
        food_matches = process.extract(query, [(to_string(obj), obj) for obj in food_results], limit=10, scorer=fuzz.ratio)
        instruction_matches = process.extract(query, [(to_string(obj), obj) for obj in instruction_results], limit=10, scorer=fuzz.ratio)
        extra_matches = process.extract(query, [(to_string(obj), obj) for obj in extra_results], limit=10, scorer=fuzz.ratio)
        transaction_matches = process.extract(query, [(str(obj.serial), obj) for obj in transaction_results], limit=10, scorer=fuzz.ratio)

        results = {
            'food': [{'uuid': match[1].uuid, 'name': match[1].name, 'price': match[1].price} for match in food_matches],
            'instruction': [{'uuid': match[1].uuid, 'name': match[1].name, 'price': match[1].price} for match in instruction_matches],
            'extra': [{'uuid': match[1].uuid, 'name': match[1].name, 'price': match[1].price} for match in extra_matches],
            'transaction': [{'serial': match[1].serial, 'total_price': match[1].total_price} for match in transaction_matches]
        }

        return Response(results)
