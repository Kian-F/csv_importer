# README

#### Welcome to the Backend of the "csv_importer" application. This backend is built using Node.js and Express to provide a robust API for the "Project Name" application.

#### Getting Started
Follow these instructions to set up and run the backend locally on your machine.

Prerequisites
Ruby installed on your machine
Ruby on Rails installed on your machine
Database: because it was a small project I used the default SQL light for the Ruby On Rails
Installing
Clone the repository from GitHub.
bash
Copy code
git clone https://github.com/Kian-F/csv_importer_frontend.git
Navigate to the backend directory.
bash
Copy code
cd project
Install the dependencies.
bash
Copy code
bundle install
Database Configuration
Configure the database connection in config/database.yml to match your local setup.

Running the Server
Run the following command to start the Rails server:

bash
Copy code
rails server -p 3001
The backend API will be accessible at http://localhost:30001.

API Endpoints
GET /api/people: Fetch a list of people.
GET /api/people/:id: Fetch a specific person by ID.

#### Folder Structure
app/controllers: Contains controllers that handle API requests.
app/models: Contains the database schema and models.
config/routes.rb: Configures the API routes and endpoints.
Deployment
To deploy the backend to a production environment, follow the deployment instructions for Ruby on Rails applications.

#### Contributing
Contributions are welcome! If you find a bug or want to add a new feature, please open an issue or submit a pull request.
# csv_importer
