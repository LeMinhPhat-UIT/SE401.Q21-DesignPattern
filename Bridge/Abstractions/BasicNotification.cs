using BridgeDemo.Implements;
using System;
using System.Collections.Generic;
using System.Text;

namespace BridgeDemo.Abstractions
{
    public class BasicNotification : Notification
    {
        public BasicNotification(INotificationSender sender)
            : base(sender) { }

        public override void Send(string message)
        {
            sender.Send(message);
        }
    }
}
