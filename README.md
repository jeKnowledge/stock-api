# stock-api

## Development 

To get the api up and running locally install Docker and then:

```shell
$ docker-compose up
```

To run commands inside the container:

```shell
$ docker-compose run web <command>
```

### ENV vars

To enable sms capabilities you have to set the twilio credentials at the `.env` file, using the `.env.example` template
