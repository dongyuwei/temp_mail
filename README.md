# TempMail
Temporary email service using gen_smtp, Elixir, and SQLite.

## Start App
- Install Erlang/OTP 27 and Elixir(1.16.3)
- mix deps.get
- mix ecto.migrate
- mix run --no-halt

## Generate temporary email address and waiting for the receipt of the email. 
http://localhost:4000/

## Send email to test the App
python3 test/send_email.py the_generated_temporary_email_address

## get email
Eg: http://localhost:4000/emails/{the_generated_temporary_email_address}

## Set domain and port of the smtp server(see config/config.exs)

```exs
config :temp_mail, TempMail.SMTPServer,
  port: 2525,
  domain: "localhost"
```

## Reference(gen-smtp  smtp_server_example)
[smtp_server_example](https://github.com/gen-smtp/gen_smtp/blob/1.2.0/src/smtp_server_example.erl)
