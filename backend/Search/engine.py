import json
from fuzzywuzzy import fuzz, process


class SearchEngine:
    def __init__(self, query, key, items):
        self.items = items
        self.query = query
        self.found = []
        self.key = key

    def get_type_corrected_query(self):
        return str(self.query).lower()

    def search_exact(self):
        query = self.get_type_corrected_query()
        exact = []
        for item in self.items:
            value = str(item[self.key]).lower()
            if str(query) in value:
                exact.append(item)
        self.found.extend(exact)

    def search_partial(self):
        query = self.get_type_corrected_query()
        yet_found = self.get_yet_found()
        partial_matches = process.extract(query, [item[self.key] for item in yet_found], limit=10,
                                          scorer=fuzz.partial_ratio)
        partial_list = [item[1] for item in partial_matches]
        for i in yet_found:
            if i[self.key] in partial_list:
                self.found.append(i)

    def search_lookalike(self):
        query = self.get_type_corrected_query()
        yet_found = self.get_yet_found()
        lookalike_matches = process.extract(query, [str(item[self.key]) for item in yet_found], limit=10,
                                            scorer=fuzz.ratio)
        lookalike_list = [item[1] for item in lookalike_matches]
        for i in yet_found:
            if i[self.key] in lookalike_list:
                self.found.append(i)

    def search(self):
        self.search_exact()
        self.search_partial()
        self.search_lookalike()
        return self.found

    def get_yet_found(self):
        yet_found = []
        found_keys = [item[self.key] for item in self.found]
        for item in self.items:
            if item[self.key] not in found_keys:
                yet_found.append(item)
        return yet_found
