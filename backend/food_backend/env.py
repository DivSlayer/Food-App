class Env:
    def get_server(self):
        with open('current_server.txt', 'r') as f:
            return f"http://{f.read()}"
