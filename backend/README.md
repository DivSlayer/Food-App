
# Backend (Django) – Food Delivery Project
[پارسی](README_FA.md)

This directory contains the Django REST API backend for the Food Delivery Project.

## Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Database Migrations](#database-migrations)
- [Management Commands](#management-commands)
- [Running the Server](#running-the-server)
- [API Endpoints](#api-endpoints)
- [Running Tests](#running-tests)
- [Contributing](#contributing)

## Overview

The Django backend provides RESTful endpoints to:
- Authenticate users (owners, customers, delivery agents)
- Manage restaurants, branches, and menus
- Handle coverage areas on the map
- Calculate financial estimations
- Process and track delivery speed and status

## Tech Stack

- **Python 3.8+**
- **Django 3.x**
- **Django REST Framework**
- **PostgreSQL** (recommended) or **SQLite**

## Prerequisites

- Python 3.8 or higher  
- pip  
- Virtualenv (optional, but recommended)  
- PostgreSQL database (or SQLite for development)  

## Installation

1. Clone the repository and navigate to the backend directory:
   ```bash
   git clone https://github.com/DivSlayer/Food-App.git
   cd backend
   ```

2. Create and activate a virtual environment (optional):
   ```bash
   python -m venv venv
   .\venv\Scripts\activate   # On Linux: source venv/bin/activate 
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Configuration
1. Open current_server.txt and write your server address there.

## Database Migrations
1. First make the migrations:
   ```bash
   python manage.py makemigrations
   ```
2. Apply migrations to set up the database schema:
   ```bash
   python manage.py migrate
   ```

## Management Commands

Before starting the server, you **must** run the custom management command `process_trans` to initialize translation tables and other prerequisites:
```bash
python manage.py process_trans
```
This command sets up necessary data structures and should be re-run whenever translation-related models change.

## Running the Server

Start the development server:
```bash
python manage.py runserver
```
The API will be available at `http://localhost:8000/api/`.

## API Endpoints
### Dashboard APIs

| Endpoint                        | Method      | Description                                                                |
|---------------------------------|-------------|----------------------------------------------------------------------------|
| `/api/dashboard/token/`         | POST        | Obtain auth token                                                          |
| `/api/dashboard/token/refresh/` | POST        | Checks refresh token and returns new access token                          |
| `/api/dashboard/details`        | GET         | Returns restaurant details                                                 |
| `/api/dashboard/transaction/`   | GET or POST | Returns a list of the restaurant's transactions and makes new transactions |
| `/api/dashboard/food/`          | GET or POST | Returns a list of the restaurant's food and makes new foods                |
| ...                             | ...         | ...                                                                        |

### Client APIs

| Endpoint                      | Method      | Description                                                            |
|-------------------------------|-------------|------------------------------------------------------------------------|
| `/api/account/token/`         | POST        | Obtain auth token                                                      |
| `/api/account/token/refresh/` | POST        | Checks refresh token and returns new access token                      |
| `/api/account/details`        | GET         | Returns client details                                                 |
| `/api/transaction/`           | GET or POST | Returns a list of the client's transactions and makes new transactions |
| `/api/close-res/`             | GET or POST | Returns a list of the closest restaurants foods                        |
| ...                           | ...         | ...                                                                    |


*(Refer to the code or API schema for full endpoint list.)*

## Running Tests

Execute the test suite with:
```bash
python manage.py test
```

## Contributing

1. Fork the repository.  
2. Create a new branch for your feature or bugfix.  
3. Write tests and documentation for your changes.  
4. Submit a pull request.

---

Happy coding! 🍔🚀
