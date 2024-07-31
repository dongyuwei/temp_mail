# TempMail
Temporary email service using gen_smtp, Elixir, and SQLite.

## Start App
- Install Erlang/OTP 27 and Elixir(1.16.3)
- mix deps.get
- mix run --no-halt

## Send email to test the App
python3 test/send_email.py

## get email
Eg: http://localhost:4000/emails/yuwei@localhost

## Set domain and port of the smtp server(see config/cofig.exs)

```exs
config :temp_mail, TempMail.SMTPServer,
  port: 2525,
  domain: "localhost"
```

## Reference(gen-smtp  smtp_server_example)
[smtp_server_example](https://github.com/gen-smtp/gen_smtp/blob/1.2.0/src/smtp_server_example.erl)
