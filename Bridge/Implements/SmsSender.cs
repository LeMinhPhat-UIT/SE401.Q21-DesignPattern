using System;
using System.Collections.Generic;
using System.Text;

namespace BridgeDemo.Implements
{
    public class SmsSender : INotificationSender
    {
        public void Send(string message)
        {
            Console.WriteLine($"[SMS] Sending: {message}");
        }
    }
}
