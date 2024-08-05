import smtplib
from email.mime.text import MIMEText
import argparse

# Set up argument parser
parser = argparse.ArgumentParser(description='Send a test email.')
parser.add_argument('to_email', help='The recipient email address')
args = parser.parse_args()

# Set up the MIME
message = MIMEText("This is a test email from Python.")
message['Subject'] = "Test email"
message['From'] = "sender@example.com"
message['To'] = args.to_email

# Send the message
server = smtplib.SMTP('localhost', 2525)
server.send_message(message)
server.quit()

print("Email sent!")
