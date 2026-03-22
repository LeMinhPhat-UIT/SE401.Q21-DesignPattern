using BridgeDemo.Implements;
using System;
using System.Collections.Generic;
using System.Text;

namespace BridgeDemo.Abstractions
{
    public class UrgentNotification : Notification
    {
        public UrgentNotification(INotificationSender sender)
            : base(sender) { }

        public override void Send(string message)
        {
            sender.Send("[URGENT] " + message);
        }
    }
}
