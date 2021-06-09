using EasyEncryption;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System;
using System.Diagnostics;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

public class Message
{
	[JsonPropertyName("string")]
	public string String { get; set; }
	[JsonPropertyName("difficulty")]
	public int Difficulty { get; set; }
}
public class Receive
{
    public static string ResolveCryptoPuzzle(string message, int difficulty)
    {
        var desired = new string('0', difficulty);

		for (int i = 0; i < int.MaxValue; i++)
		{
            string solutionCandidate = SHA.ComputeSHA256Hash(message + i.ToString());

            if (solutionCandidate.Substring(0, difficulty) == desired)
            {
                return $"{message}{i}";
            }
        }

        return string.Empty;
    }

    public static void Main()
    {
		var factory = new ConnectionFactory() { HostName = "localhost" };
		using (var connection = factory.CreateConnection())
		using (var channel = connection.CreateModel())
		{
			Console.WriteLine("Waiting for messages.");

			var consumer = new EventingBasicConsumer(channel);
			consumer.Received += (model, ea) =>
			{
				var body = ea.Body.ToArray();
				var message = Encoding.UTF8.GetString(body);
				Console.WriteLine("Received {0}", message);
				var readOnlySpan = new ReadOnlySpan<byte>(body);
				Message deserializedMessage = JsonSerializer.Deserialize<Message>(readOnlySpan);
				var solution = ResolveCryptoPuzzle(deserializedMessage.String, deserializedMessage.Difficulty);
				var solutionBytes = Encoding.UTF8.GetBytes(solution);

				channel.BasicPublish(exchange: "", routingKey: "crypto-puzzle-responses", basicProperties: null, body: solutionBytes);
			};
			channel.BasicConsume(queue: "crypto-puzzle-inquiries", autoAck: true, consumer: consumer);

			Console.WriteLine(" Press [enter] to exit.");
			Console.ReadLine();
		}
	}
}