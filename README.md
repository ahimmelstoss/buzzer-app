# Buzzer App

Our Buzzer App runs on a Raspberry Pi connected to an apartment buzzer/intercom. A simple Sinatra application enables the user (of the app, which requires a log-in) to trigger the buzzer to open the downstairs door. The buzzer is triggered through C to buzz for 5 seconds. 

## API Documentation

### POST /login

Parameters: username, password, api
Returns: authenticated?, admin?

### GET /buzz

Parameters: api
Returns: buzz? or 500 Status

### POST /new_user

Parameters: username, password, api
Returns: new_user?

## Stack

C, Ruby, Sinatra, ActiveRecord, HTML, cat photos

## License

[MIT](LICENSE)
