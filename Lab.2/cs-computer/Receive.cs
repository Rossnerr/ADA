using EasyEncryption;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System;
using System.Diagnostics;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

public class Puzzle
{
	[JsonPropertyName("string")]
	public string String { get; set; }
	[JsonPropertyName("difficulty")]
	public int Difficulty { get; set; }
}

public class Receive
{
    public static string SolvePuzzle(string message, int difficulty)
    {
        var desired = new string('0', difficulty);

		for (int i = 0; i < int.MaxValue; i++)
		{
            string solutionCandidate = SHA.ComputeSHA256Hash(message + i.ToString());

            if (solutionCandidate.Substring(0, difficulty) == desired)
            {
				Console.WriteLine("Puzzle solved:");
				Console.WriteLine($"Hash: {solutionCandidate}");
				Console.WriteLine($"Solution: {message}{i}");
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
			Console.WriteLine($"Waiting for messages in crypto-puzzle-inquiries. To exit press CTRL + C.");

			var consumer = new EventingBasicConsumer(channel);
			consumer.Received += (model, ea) =>
			{
				var body = new ReadOnlySpan<byte>(ea.Body.ToArray());
				var message = JsonSerializer.Deserialize<Puzzle>(body);
				Console.WriteLine($"Puzzle with string {message.String} and difficulty {message.Difficulty} received.");

				var solution = SolvePuzzle(message.String, message.Difficulty);

				channel.BasicPublish(exchange: "", routingKey: "crypto-puzzle-responses", basicProperties: null, body: Encoding.UTF8.GetBytes(solution));
			};
			channel.BasicConsume(queue: "crypto-puzzle-inquiries", autoAck: true, consumer: consumer);

			Console.ReadKey();
		}
	}
}