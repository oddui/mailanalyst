# MailAnalyst

Catches mail and send event to GoogleAnalytics

## Run

```
$ ruby mailanalyst.rb
```

## Docker

Build image

```
$ docker -t mailanalyst .
```

Run

```
$ docker run -d -p 25:25 mailanalyst
```

```
$ docker run -it --rm mailanalyst /bin/sh
```
