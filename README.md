# yeetyottza

Free classroom-oriented instructor-moderated question and answer forum. Inspired by [Piazza](https://piazza.com/).

## Setting up the app

1. Install dependencies
    * PostgreSQL, Python3, pip: `sudo apt install build-essential postgresql libpq-dev python3 python3-pip`
    * [Flutter](https://flutter.dev/docs/get-started/install)
1. Set up database
    1. Start the Postgres service: `sudo service postgresql start`
    1. Change the password of the postgres user
        1. Open psql: `sudo -u postgres psql`
        1. Change the password: `\password postgres`
            * Remember this, you'll need it later!
        1. Quit psql: `\q`
    1. Create the YeetYottza database: `sudo -u postgres createdb yeetyottza`
    1. Change Postgres's authentication mode
        1. Find the configuration file: `sudo -u postgres psql -c "show hba_file;"`
        1. Open the configuration file: `sudo vim [configuration file path]`
        1. Change "md5" to "password" in these lines:
            ```
            # IPv4 local connections:
            host    all             all             127.0.0.1/32            md5
            # IPv6 local connections:
            host    all             all             ::1/128                 md5
            ```
1. Set up back end
    1. Navigate to the back end directory
    1. Install the dependencies in the Django project: `pip3 install -r requirements.txt`
    1. Set up the environment variables file
        1. Copy .env.example and rename it to .env
        1. Populate the fields in the file
    1. Run Django migrations: `python3 manage.py migrate`
1. Set up front end
    1. Navigate to the front end directory
    1. Install the dependencies in the Flutter project: `flutter pub get`
    1. Set up the environment variables file
        1. Copy .env.example and rename it to .env
        1. Populate the fields in the file

## Running the app

1. Run back end: `python3 manage.py runserver`
1. Run front end: `flutter run`
