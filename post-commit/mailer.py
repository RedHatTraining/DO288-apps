from mailer import Mailer
from mailer import Message

message = Message(From="me@example.com",
                          To="you@example.com",
                                            charset="utf-8")
message.Subject = "An HTML Email"
message.Html = """This email uses <strong>HTML</strong>!"""
message.Body = """This is alternate text."""

sender = Mailer('smtp.example.com')
sender.send(message)
