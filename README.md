# stock-api

Stock is an inventory manager that enables us to keep track on our belongings.

It is integrated with Slack, so any item can be booked or returned through that platform.
It is also integrated with Twilio, so anyone who's on the waiting list for an item, will get SMS warned when that item becomes available again.

This repo contains the API that powers up the platform.

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
