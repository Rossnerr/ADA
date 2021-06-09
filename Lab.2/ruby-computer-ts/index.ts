import amqp from "amqplib";
import { createHash } from "crypto";

interface Puzzle {
  string: string;
  difficulty: number;
}

const solvePuzzle = ({ string, difficulty }: Puzzle) => {
  let i = 0;
  const needle = Array(difficulty).fill("0").join("");
  while (true) {
    const candidate = string + i;
    const hash = createHash("sha256").update(candidate).digest("hex");
    if (hash.slice(0, difficulty) === needle) {
      console.log(`Found solution  ${hash}, ${candidate}`);
      return candidate;
    }
    i++;
  }
};

const main = async () => {
  const conn = await amqp.connect("amqp://guest:guest@localhost:5672");
  const ch = await conn.createChannel();
  await ch.assertQueue("crypto-puzzle-inquiries", {
    autoDelete: true,
    durable: false,
  });
  ch.consume("crypto-puzzle-inquiries", (msg) => {
    if (msg !== null) {
      const puzzle: Puzzle = JSON.parse(msg.content.toString());
      const solution = solvePuzzle(puzzle);
      ch.publish("", msg.properties.replyTo, Buffer.from(solution), {
        correlationId: msg.properties.correlationId,
      });
    }
  });
};

main();
