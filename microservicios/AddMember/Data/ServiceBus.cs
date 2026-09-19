using RabbitMQ.Client;
using System.Text;
using System.Text.Json;

namespace AddMember.Data
{
    public class ServiceBus
    {
        private readonly string _hostName;
        private readonly string _queueName;

        public ServiceBus(string hostName, string queueName)
        {
            _hostName = hostName;
            _queueName = queueName;
        }

        public async Task SendMessageAsync(string name, string lastname, string birthyear)
        {
            var factory = new ConnectionFactory() { HostName = _hostName };
            
            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            // Declara la cola pickage si aún no existe en RabbitMQ
            channel.QueueDeclare(
                queue: _queueName,
                durable: true,
                exclusive: false,
                autoDelete: false,
                arguments: null);

            var messageBody = $"Name: {name}, Lastname: {lastname}, Birthyear: {birthyear}";
            var jsonMessage = JsonSerializer.Serialize(messageBody);
            var body = Encoding.UTF8.GetBytes(jsonMessage);

            var properties = channel.CreateBasicProperties();
            properties.Persistent = true;

            channel.BasicPublish(
                exchange: "",
                routingKey: _queueName,
                basicProperties: properties,
                body: body);

            await Task.CompletedTask;
        }
    }
}