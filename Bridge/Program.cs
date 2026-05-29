using BridgeDemo.Abstractions;
using BridgeDemo.Implements;

Notification notification1 = new BasicNotification(new EmailSender());
notification1.Send("Hello World");

Console.WriteLine();

// Urgent + SMS
Notification notification2 = new UrgentNotification(new SmsSender());
notification2.Send("Server is down!");

Console.WriteLine();

// Mix thoải mái
Notification notification3 = new UrgentNotification(new EmailSender());
notification3.Send("Database error!");