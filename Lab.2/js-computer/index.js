#!/usr/bin/env node

var amqp = require('amqplib/callback_api');
var crypto = require('crypto');

function solvePuzzle(string, difficulty){
	const needle = Array(difficulty).fill("0").join("");

	for (i = 0; i < Number.MAX_SAFE_INTEGER; i++) {
		const candidate = string + i;
		const hash = crypto.createHash("sha256").update(candidate).digest("hex");

		if (hash.slice(0, difficulty) === needle) {
			console.log('Puzzle solved:');
			console.log(`Hash: ${hash}`);
			console.log(`Solution: ${candidate}`)
			return candidate;
		}
	}

	throw 'Puzzle was not solved';
}

amqp.connect('amqp://localhost', function(error0, connection) {
  if (error0) {
    throw error0;
  }
  connection.createChannel(function(error1, channel) {
    if (error1) {
      throw error1;
    }
    var queue = 'crypto-puzzle-inquiries';

    channel.assertQueue(queue, {
		autoDelete: true,
		durable: false
	});

	console.log(`Waiting for messages in ${queue}. To exit press CTRL+C`);

	channel.consume(queue, function(msg) {
		var puzzle = JSON.parse(msg.content.toString());
		console.log(`Puzzle with string ${puzzle.string} and difficulty ${puzzle.difficulty} received.`);
		var solution = solvePuzzle(puzzle.string, puzzle.difficulty);
		channel.sendToQueue('crypto-puzzle-responses', Buffer.from(solution));
	}, {
		noAck: true
	});
  });
});