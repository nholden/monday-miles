# Monday Miles
Strava data visualizer that helps athletes celebrate Monday finishes

## Installation
```
git clone git://github.com/nholden/monday-miles
cd monday-miles
brew install redis postgresql heroku
bundle install
yarn
cp .env.example .env
bundle exec rake db:reset
```

## Getting started
Sign up for a Strava API key at [https://developers.strava.com](https://developers.strava.com) and a Google Static Maps API key at [https://developers.google.com/maps/documentation/static-maps/](https://developers.google.com/maps/documentation/static-maps/) and update `.env`.

Start these long-running processes in separate terminal windows:

```
heroku local
webpack-dev-server
```

Monday Miles should be accessible at http://localhost:3000 (or whichever port you specify in `.env`).

## Testing
```
bundle exec rake
```

## Contributing
Contributions are welcome from everyone! Feel free to make a pull request or use GitHub issues for help getting started, to report bugs, or to make feature requests.

## License
This project was created by [Nick Holden](https://nickholen.io) and is licensed under the terms of the MIT license.
