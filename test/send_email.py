import smtplib
from email.mime.text import MIMEText

# Set up the MIME
message = MIMEText("This is a test email from Python.")
message['Subject'] = "Test email"
message['From'] = "sender@example.com"
message['To'] = "recipient@example.com"

# Send the message
server = smtplib.SMTP('localhost', 2525)
server.send_message(message)
server.quit()

print("Email sent!")

# python3 test/send_email.py
