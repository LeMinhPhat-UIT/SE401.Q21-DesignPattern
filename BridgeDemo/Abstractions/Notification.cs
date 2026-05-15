using BridgeDemo.Implements;
using System;
using System.Collections.Generic;
using System.Text;

namespace BridgeDemo.Abstractions
{
    public abstract class Notification
    {
        protected INotificationSender sender;

        protected Notification(INotificationSender sender)
        {
            this.sender = sender;
        }

        public abstract void Send(string message);
    }

}
