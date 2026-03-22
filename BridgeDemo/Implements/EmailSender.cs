using System;
using System.Collections.Generic;
using System.Text;

namespace BridgeDemo.Implements
{
    public class EmailSender : INotificationSender
    {
        public void Send(string message)
        {
            Console.WriteLine($"[Email] Sending: {message}");
        }
    }
}
