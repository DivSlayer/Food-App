import os

folders = os.listdir()

installed_apps = ["Account",
                  "Category",
                  "Checkout",
                  "Drink",
                  "Food",
                  "Utils",
                  "Restaurant",
                  "Address",
                  "API",
                  "Instruction",
                  "Extras", "Transaction"]

for folder in installed_apps:
    if os.path.isdir(folder):
        if os.path.isdir(f'{folder}/migrations'):
            files = os.listdir(f'{folder}/migrations')
            for file in files:
                if file != '__init__.py' and file != "__pycache__":
                    os.remove(f'{folder}/migrations/{file}')
