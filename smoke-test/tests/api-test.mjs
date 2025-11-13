import { hello } from "@heiwa4126/hello4";

console.log("🔥 Testing ES Modules API...");
const result = hello();
console.log(`Result: ${result}`);

if (result !== "Hello!") {
	console.error("❌ Expected 'Hello!', got:", result);
	process.exit(1);
}

console.log("✅ ES Modules API test passed!");
